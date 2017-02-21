function Add-JIRAIssue {
	<#
	.SYNOPSIS
		Create a Jira Issue

	.DESCRIPTION
		#ToDo
	
	.PARAMETER Project
		#ToDo
	
	.PARAMETER IssueType
		#ToDo
	
	.PARAMETER Reporter
		#ToDo
	
	.PARAMETER Assignee
		#ToDo
	
	.PARAMETER Version
		#ToDo
	
	.PARAMETER FixVersion
		#ToDo
	
	.PARAMETER Components
		#ToDo
	
	.PARAMETER RemainingEstimate
		#ToDo
	
	.PARAMETER Priority
		#ToDo
	
	.PARAMETER Flaged
		#ToDo
	
	.PARAMETER ParentTask
		#ToDo
	
	.PARAMETER Session
		#ToDo
	
	.EXAMPLE
		#ToDo

	.OUTPUTS
		System.Management.Automation.PSObject
	#>
	[CmdletBinding(
		#SupportsShouldProcess=$true,
		DefaultParameterSetName = 'ProjectName'
	)]
	Param(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = 'Project'
		)]
		[JIRAProject] $Project,
		[Parameter(
			Mandatory = $true,
			ParameterSetName = 'ProjectKey'
		)]
		[String] $ProjectKey,
		[Parameter(
			Mandatory = $true
		)]
		[System.String] $IssueType,
		[Parameter(
			Mandatory = $false
		)]
		[System.String] $Summary,
		[Parameter(
			Mandatory = $false
		)]
		[System.String] $Description,
		[Parameter(
			Mandatory = $false
		)]
		[System.String] $Reporter,
		[Parameter(
			Mandatory = $false
		)]
		[System.String] $Assignee,
		[Parameter(
			Mandatory = $false
		)]
		[System.String[]] $Versions,
		[Parameter(
			Mandatory = $false
		)]
		[System.String[]] $FixVersions,
		[Parameter(
			Mandatory = $false
		)]
		[System.String[]] $Components,
		[Parameter(
			Mandatory = $false
		)]
		[System.Nullable[TimeSpan]] $TimeEstimate,
		[Parameter(
			Mandatory = $false
		)]
		[System.String] $Priority,
		[Parameter(
			Mandatory = $false
		)]
		[System.String] $Flagged,
		[Parameter(
			Mandatory = $false
		)]
		[System.String] $ParentTaskKey,
		[Parameter(
			Mandatory = $false
		)]
		[System.Collections.Hashtable] $Properties,
		[Parameter(
			Mandatory = $false
		)]
		[AtlassianSession] $Session = (Get-AtlassianSession)
	)
	Begin{}
	Process{
		$request = @{}
		$fields = @{}
		# Add Project
		if($ProjectKey) {
			$fields.Add('project',@{key=$ProjectKey})
		} else {
			$fields.Add('project',@{key=$Project.Key})
		}
		# Check if Issue type exists
		$objIssueType = $Project.IssueTypes | Where-Object{($_.Id -eq $IssueType) -or ($_.Name -eq $IssueType)}
		if($objIssueType){
			$fields.Add('issuetype',@{name=$objIssueType.Name})
		}
		if($Summary){
			$fields.Add('summary',$Summary)
		}
		if($Description){
			$fields.Add('description',$Summary)
		}
		if($Reporter){
			$fields.Add('reporter',@{name=$Reporter})
		}
		if($Assignee){
			$fields.Add('assignee',@{name=$Assignee})
		}
		if($Versions){
			$versionsList = @{}
			$Versions | ForEach-Object{
				$versionsList.Add('name',$_)
			}
			$fields.Add('versions',@($versionsList))
		}
		if($FixVersions){
			$versionsList = @{}
			$FixVersions | ForEach-Object{
				$versionsList.Add('name',$_)
			}
			$fields.Add('fixVersions',@($versionsList))
		}
		if($Components){
			$componentsList = @{}
			$Components | ForEach-Object{
				$componentsList.Add('name',$_)
			}
			$fields.Add('components',@($componentsList))
		}
		if($TimeEstimate -ne $null){
			$timeTracking = @{}
			$formatedTime = ('{0}d {1}h {2}m' -f ($TimeEstimate.Days,$TimeEstimate.Hours,$TimeEstimate.Minutes))
			$timeTracking.Add('originalEstimate',$formatedTime)
			$timeTracking.Add('remainingEstimate',$formatedTime)
			$fields.Add('timetracking',$timeTracking)
		}
		if($Priority){
			$fields.Add('priority',@{name=$Priority})
		}
		if($ParentTaskKey){
			$fields.Add('parent',@{key=$ParentTaskKey})
		}

		foreach($key in $Properties.Keys){
			$fields.Add(($key).ToLower(),$Properties.$key)
		}

		$request.Add('fields',$fields)
		$request = $request | ConvertTo-Json -Depth 3
		Write-Debug -Message $request
		Invoke-APIRequest -Method 'POST' -Uri 'rest/api/2/issue/' -Body $request -Session $Session
	}
	End{}
}