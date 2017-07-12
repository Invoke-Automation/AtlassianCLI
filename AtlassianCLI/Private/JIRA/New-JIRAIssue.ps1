function New-JIRAIssue {
	<#
		.SYNOPSIS
			Creates a JIRAIssue objects.
		.DESCRIPTION
			The New-JIRAIssue cmdlet creates a JIRAIssue object based on specified input.
		.PARAMETER Uri
			Specifies the url to be used to retrieve the JIRAIssue object.
		.PARAMETER Session
			Specifies the AtlassianSession to use to perform this task.
			If none is specified Get-AtlassianSession is called.
		.EXAMPLE
			C:\PS> New-JIRAIssue -Uri '/rest/api/latest/issue/10000' -Session $Session
			Gets the issue with id 10000
		.INPUTS
			None or System.String
			A JIRAIssue object is retrieved using the Uri parameter
		.OUTPUTS
			JIRAIssue
			Returns a JIRAIssue object.
		.NOTES
		.LINK
			http://docs.invoke-automation.com
	#>
	[CmdletBinding(
		#SupportsShouldProcess=$true
	)]
	Param(
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $true
		)]
		[System.String] $Uri,
		[Parameter(
			Mandatory = $false
		)]
		[AtlassianSession] $Session = (Get-AtlassianSession)
	)
	Begin {
		$DATETIMEPATTERN = $SETTINGS.Atlassian.DateTimeStringPattern

		# Helper Functions
		function Get-JIRAIssueObject {
			Param(
				[Parameter(
					Mandatory = $true
				)][System.String] $Uri
			)
			$method = 'GET'
			Invoke-APIRequest -Method $method -Uri $Uri -Session $Session | % {
				$issue = $_
				$properties = @{
					Self = $issue.self
					Id   = $issue.id
					Key  = $issue.key
				}
				# Fields
				if ($issue.fields) {
					$fields = @{}
					$issue.fields | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | % {
						switch ($_) {
							# JIRAIssueType fields
							issuetype {
								# Issue Type
								$name = 'IssueType'
								if ($issue.fields."$_".self) {
									$value = ($issue.fields."$_".self | New-JIRAIssueType)
								} else {
									$value = $null
								}
								$properties.Add($name, $value)
							}
							# JIRAProject fields
							project {
								# Project
								$name = 'Project'
								if ($issue.fields."$_".self) {
									$value = ($issue.fields."$_".self | New-JIRAProject)
								} else {
									$value = $null
								}
								$properties.Add($name, $value)
							}
							# JIRAVersion fields
							versions {
								# Affects Version/s
								$name = 'Versions'
								if ($issue.fields."$_".self) {
									$value = ($issue.fields."$_".self | New-JIRAVersion)
								} else {
									$value = $null
								}
								$properties.Add($name, $value)
							}
							fixVersions {
								# Fix Version/s
								$name = 'FixVersions'
								if ($issue.fields."$_".self) {
									$value = ($issue.fields."$_".self | New-JIRAVersion)
								} else {
									$value = $null
								}
								$properties.Add($name, $value)
							}
							# JIRAComponent fields
							components {
								# Components
								$name = 'Components'
								if ($issue.fields."$_".self) {
									$value = ($issue.fields."$_".self | New-JIRAComponent)
								} else {
									$value = $null
								}
								$properties.Add($name, $value)
							}
							# JIRAUser fields
							creator {
								# Creator
								$name = 'Creator'
								if ($issue.fields."$_".self) {
									$value = ($issue.fields."$_".self | New-JIRAUser)
								} else {
									$value = $null
								}
								$properties.Add($name, $value)
							}
							reporter {
								# Reporter
								$name = 'Reporter'
								if ($issue.fields."$_".self) {
									$value = ($issue.fields."$_".self | New-JIRAUser)
								} else {
									$value = $null
								}
								$properties.Add($name, $value)
							}
							assignee {
								# Assignee
								$name = 'Assignee'
								if ($issue.fields."$_".self) {
									$value = ($issue.fields."$_".self | New-JIRAUser)
								} else {
									$value = $null
								}
								$properties.Add($name, $value)
							}
							watches {
								# Watchers
								$name = 'Watchers'
								if ($issue.fields."$_".self) {
									$watches = (Invoke-APIRequest -Method 'GET' -Session $Session -Uri $issue.fields."$_".self)
									if ($watches.watchers.self) {
										$value = ($watches.watchers.self | New-JIRAUser)
									} else {
										$value = $null
									}
								} else {
									$value = $null
								}
								$properties.Add($name, $value)
							}
							votes {
								# Votes
								$name = 'Voters'
								if ($issue.fields."$_".self) {
									$votes = (Invoke-APIRequest -Method 'GET' -Session $Session -Uri $issue.fields."$_".self)
									if ($votes.voters.self) {
										$value = ($votes.voters.self | New-JIRAUser)
									} else {
										$value = $null
									}
								} else {
									$value = $null
								}
								$properties.Add($name, $value)
							}
							# JIRAIssueWorklog fields
							worklog {
								# Log Work
								$name = 'WorkLog'
								if ($issue.fields."$_".worklogs.self) {
									$value = $issue.fields."$_".worklogs.self  | New-JIRAIssueWorklog
								} else {
									$value = $null
								}
								$properties.Add($name, $value)
							}
							# JIRAIssueComment fields
							comment {
								# Comments
								$name = 'Comments'
								if ($issue.fields."$_".comments.self) {
									$value = ($issue.fields."$_".comments.self | New-JIRAIssueComment)
								} else {
									$value = $null
								}
								$properties.Add($name, $value)
							}
							# JIRAIssue fields
							subtasks {
								# Sub-Tasks
								$name = 'SubTasks'
								if ($issue.fields."$_".self) {
									$value = ($issue.fields."$_".self | New-JIRAIssue)
								} else {
									$value = $null
								}
								$properties.Add($name, $value)
							}
							# Free text fields
							summary {
								# Summary
								$name = 'Summary'
								if ($issue.fields."$_") {
									$value = $issue.fields."$_"
								} else {
									$value = $null
								}
								$properties.Add($name, $value)
							}
							description {
								# Description
								$name = 'Description'
								if ($issue.fields."$_") {
									$value = $issue.fields."$_"
								} else {
									$value = $null
								}
								$properties.Add($name, $value)
							}
							# Specials
							timespent {
								# Time Spent
								$name = 'TimeSpent'
								if ($issue.fields."$_") {
									$value = [TimeSpan]::FromSeconds($issue.fields."$_")
								} else {
									$value = $null
								}
								$properties.Add($name, $value)
							}
							aggregatetimespent {
								# Sum Time Spent
								$name = 'TotalTimeSpent'
								if ($issue.fields."$_") {
									$value = [TimeSpan]::FromSeconds($issue.fields."$_")
								} else {
									$value = $null
								}
								$properties.Add($name, $value)
							}
							timeestimate {
								# Remaining Estimate
								$name = 'RemainingEstimate'
								if ($issue.fields."$_") {
									$value = [TimeSpan]::FromSeconds($issue.fields."$_")
								} else {
									$value = $null
								}
								$properties.Add($name, $value)
							}
							status {
								# Status
								$name = 'Status'
								if ($issue.fields."$_".name) {
									$value = $issue.fields."$_".name
								} else {
									$value = $null
								}
								$properties.Add($name, $value)
							}
							priority {
								# Priority
								$name = 'Priority'
								if ($issue.fields."$_".name) {
									$value = $issue.fields."$_"
								} else {
									$value = $null
								}
								$properties.Add($name, $value)
							}
							customfield_10000 {
								# Flagged
								$name = 'Flagged'
								if ($issue.fields."$_".value) {
									$value = $issue.fields."$_"
								} else {
									$value = $null
								}
								$properties.Add($name, $value)
							}
							customfield_10004 {
								# Sprint
								$name = 'Sprint'
								if ($issue.fields."$_") {
									$value = ($issue.fields."$_" -replace '^.*,name=([^,]*),.*$', '$1')
								} else {
									$value = $null
								}
								$properties.Add($name, $value)
							}
							Default {
								$name = $_
								if ($issue.fields."$_") {
									if ($issue.fields."$_".GetType().Name -eq 'String') {
										if ($issue.fields."$_" -match $DATETIMEPATTERN) {
											$value = ($issue.fields."$_" | ConvertFrom-AtlassianDateTime)
										} else {
											$value = $issue.fields."$_"
										}
									} else {
										$value = $issue.fields."$_"
									}
								} else {
									$value = $null
								}
								$fields.Add($name, $value)
							}
						}

					}
					$properties.Add('Fields', $fields)
				} else {
					$properties.Add('Fields', $null)
				}
					
				# Create Object
				New-Object -TypeName JIRAIssue -Property $properties
			}
		}
	}
	Process {
		if ($Uri) {
			$outpuObject = Get-JIRAIssueObject -Uri $Uri
		}
		if ($outpuObject) {
			$outpuObject
		} else {
			throw 'No result for request'
		}
	}
	End {}
}