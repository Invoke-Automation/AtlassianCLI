function New-JIRAIssueWorklog {
	<#
		.SYNOPSIS
			Creates a JIRAIssueWorklog objects.

		.DESCRIPTION
			The New-JIRAIssueWorklog cmdlet creates a JIRAIssueWorklog object based on specified input.
		
		.PARAMETER Uri
			Specifies the url to be used to retrieve the JIRAIssueWorklog object.
		
		.PARAMETER Key
			Specifies the key to be used to retrieve the JIRAIssueWorklog object.

		.PARAMETER Session
			Specifies the AtlassianSession to use to perform this task.
			If none is specified Get-AtlassianSession is called.
		
		.EXAMPLE
			#ToDo
		
		.INPUTS
			None or System.String
			A JIRAIssueWorklog object is retrieved using the Uri parameter

		.OUTPUTS
			JIRAIssueWorklog
			Returns a JIRAIssueWorklog object.
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
	Begin{
		# Helper Functions
		function Get-JIRAIssueWorklogObject {
			Param(
				[Parameter(
					Mandatory = $true
				)][System.String] $Uri
			)
			$method = 'GET'
			Invoke-APIRequest -Method $method -Uri $Uri -Session $Session | %{
					New-Object -TypeName JIRAIssueWorklog -Property @{
						Self = $_.self
						Id = $_.id
						IssueId = $_.issueId
						Author = $_.author.self | New-JIRAUser
						UpdateAuthor = $_.updateAuthor.self | New-JIRAUser
						Comment = $_.comment
						Created = $_.created | ConvertFrom-AtlassianDateTime
						Updated = $_.updated | ConvertFrom-AtlassianDateTime
						Started = $_.started | ConvertFrom-AtlassianDateTime
						TimeSpent = [Timespan]::FromSeconds($_.timeSpentSeconds)
					}
				}
		}
	}
	Process{
		if($Uri) {
			$outpuObject = Get-JIRAIssueWorklogObject -Uri $Uri
		}
		if($outpuObject){
			$outpuObject
		} else {
			throw 'No result for request'
		}
	}
	End{}
}