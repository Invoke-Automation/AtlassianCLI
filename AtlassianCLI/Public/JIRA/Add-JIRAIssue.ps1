function Add-JIRAIssue {
	<#
		.SYNOPSIS
			Creates a new JIRA issue
		.DESCRIPTION
			The Add-JIRAIssue cmdlet  gets a specified JIRAIssue object or performs a search to get multiple JIRAIssue objects.
		.PARAMETER Project
			Specifies the JIRAProject in which the issue should be created.
		.PARAMETER ProjectKey
			Specifies the key of the JIRA project in which the issue should be created.
		.PARAMETER IssueType
			Specifies the name of the issue type for the new JIRA issue
		.PARAMETER Summary
			Specifies the summary for for the new JIRA issue
		.PARAMETER Description
			Specifies the description for for the new JIRA issue
		.PARAMETER Reporter
			Specifies the account name of the reporter for for the new JIRA issue
		.PARAMETER Assignee
			Specifies the account name of the assignee for for the new JIRA issue
		.PARAMETER Versions
			Specifies the (list of) affected version(s) for for the new JIRA issue
		.PARAMETER FixVersions
			Specifies the (list of) fix version(s) for for the new JIRA issue
		.PARAMETER Components
			Specifies the (list of) component(s) for for the new JIRA issue
		.PARAMETER TimeEstimate
			Specifies the estimated time for for the new JIRA issue
		.PARAMETER Priority
			Specifies the name of the priority for for the new JIRA issue
		.PARAMETER ParentTaskKey
			Specifies the key of the parent task for for the new JIRA issue
			This should only be specified for issuetypes that are sub-tasks
		.PARAMETER Properties
			Specifies the (list of) extra propertie(s) for for the new JIRA issue
		.PARAMETER Session
			Specifies the AtlassianSession to use to perform this task.
			If none is specified Get-AtlassianSession is called.
		.EXAMPLE
			PS C:\> Add-JIRAIssue -ProjectKey 'TEST' -IssueType 'Task' -Summary 'Task Test' -Description 'My first task'
			Gets all issues returned by the JQL filter 'project=TEST' for the currently loaded session.
		.EXAMPLE
			PS C:\> Add-JIRAIssue -Project $project -IssueType 'Task' -Summary 'Big Test' -Description 'Big Issue' -Assignee 'Test' -Priority 'Highest' -FixVersions 'Test Version' -Components 'Test Component' -TimeEstimate (New-TimeSpan -Hours 1) -Properties @{labels=@('test','demo')}
			Gets all issues returned by the JQL filter 'project=TEST' for the currently loaded session.
		.EXAMPLE
			PS C:\> Add-JIRAIssue -ProjectKey 'TEST' -IssueType 'Sub-task' -Summary 'Sub-Task Test' -Description 'Smaller issue' -Reporter 'Test' -Assignee 'Test' -Priority 'Low' -Versions 'Test Version' -ParentTaskKey $createdTask.key -Properties @{labels=@('uber')}
			Gets all issues returned by the JQL filter 'project=TEST' for the currently loaded session.
		.INPUTS
			None
			You cannot pipe input to this cmdlet.
		.OUTPUTS
			JIRAIssue
			Returns one or more JIRAIssue objects.
		.NOTES
	#>
	[CmdletBinding(
		#SupportsShouldProcess=$true,
		DefaultParameterSetName = 'ProjectName',
		HelpURI="https://github.com/Invoke-Automation/AtlassianCLI/Add-JIRAIssue.md"
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