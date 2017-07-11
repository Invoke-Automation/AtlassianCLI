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
		HelpURI="https://invoke-automation.github.io/AtlassianCLI/Add-JIRAIssue"
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
		# Initialise and check fields
		$fields = @{}
		# Add Project
		if($ProjectKey) {
			$fields.Add('project',@{key=$ProjectKey})
		} else {
			$fields.Add('project',@{key=$Project.Key})
		}
		# Check if Issue type exists
		if($Project){
			$objIssueType = $Project.IssueTypes | Where-Object{($_.Id -like $IssueType) -or ($_.Name -like $IssueType)}
			if($objIssueType){
				$fields.Add('issuetype',@{name=$objIssueType.Name})
			} else {
				throw ('Issue type does not exist in {0}' -f $Project)
			}
		} else {
			if($IssueType){
				$fields.Add('issuetype',@{name=$IssueType})
			}
		}
		if($Summary){
			$fields.Add('summary',$Summary)
		}
		if($Description){
			$fields.Add('description',$Summary)
		}
		if($Reporter){
			$fields.Add('reporter',@{name=$Reporter})
		} else {
			$fields.Add('reporter',@{name=$Session.Credential.UserName})
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

		# Check if all required fields are present
		$validRequest = $true
		$invalidRequestMessage = @()
		$createmeta = Invoke-APIRequest -Method 'GET' -Uri ('rest/api/2/issue/createmeta?projectKeys={0}&issuetypeNames={1}&expand=projects.issuetypes.fields' -f $fields.project.key,$fields.issuetype.name) -Session $Session
		foreach($property in $createmeta.projects.issuetypes.fields.psobject.Properties){
			if($property.Value.required -eq 'True'){
				if(-not $fields.($property.Name)){
					$validRequest = $false
					$invalidRequestMessage += ('{0} is a required field for issues with issuetype {1} in project {2}' -f $property.Name,$fields.issuetype.name,$fields.project.key)
				}
			}
		}

		# Invoke request if valid
		if($validRequest){
			Write-Verbose -Message 'Valid Request'
			$request = @{}
			$request.Add('fields',$fields)
			$request = $request | ConvertTo-Json -Depth 3
			Write-Debug -Message $request
			$requestResult = Invoke-APIRequest -Method 'POST' -Uri 'rest/api/2/issue/' -Body $request -Session $Session
			if($requestResult -ne $null){
				$output = @()
				foreach($obj in $requestResult) {
					$output += New-JIRAIssue -Uri $obj.self
				}
				$output
			} else {
				$null
			}
		} else {
			foreach($message in $invalidRequestMessage){
				Write-Error -Message $message
			}
		}
	}
	End{}
}