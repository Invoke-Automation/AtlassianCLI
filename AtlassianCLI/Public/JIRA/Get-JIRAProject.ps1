function Get-JIRAProject {
	<#
		.SYNOPSIS
			Get one or more JIRAProject objects.
		.DESCRIPTION
			The Get-JIRAProject cmdlet gets a specified JIRAProject object or performs a search to get multiple JIRAProject objects.
		.PARAMETER Key
			Specifies the key to be used to retrieve the JIRAProject object(s).
		.PARAMETER Name
			Specifies the full name or a part of the name used to retrieve the JIRAProject object(s).
		.PARAMETER All
			Specifies if you want to retrieve all JIRAProjects available to the specified AtlassianSession.
		.PARAMETER Session
			Specifies the AtlassianSession to use to perform this task.
			If none is specified Get-AtlassianSession is called.
		.EXAMPLE
			PS C:\> Get-JIRAProject -Name 'Test'
			Get all projects that have 'Test' in their name using the already imported AtlassianSession
		.INPUTS
			None
			You cannot pipe input to this cmdlet.
		.OUTPUTS
			JIRAProject
			Returns one or more JIRAProject objects.
		.NOTES
		.LINK
			http://docs.invoke-automation.com
	#>
	[CmdletBinding(
		#SupportsShouldProcess=$true,
		HelpURI = "https://invoke-automation.github.io/Invoke-Documentation/projects/AtlassianCLI/docs/Get-JIRAProject"
	)]
	Param(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = 'Key'
		)]
		[String] $Key,
		[Parameter(
			Mandatory = $true,
			ParameterSetName = 'Name'
		)]
		[String] $Name,
		[Parameter(
			Mandatory = $true,
			ParameterSetName = 'All'
		)]
		[Switch] $All,
		[Parameter(
			Mandatory = $false
		)]
		[AtlassianSession] $Session = (Get-AtlassianSession)
	)
	Begin {}
	Process {
		if ($Key) {
			$method = 'GET'
			$uri = ('{0}/project/{1}' -f $SETTINGS.API.Uri, $Key)
			$requestResult = Invoke-APIRequest -Method $method -Uri $uri -Session $Session
		} elseif ($Name) {
			$method = 'GET'
			$uri = ('{0}/project/' -f $SETTINGS.API.Uri)
			$requestResult = Invoke-APIRequest -Method $method -Uri $uri -Session $Session | Where-Object {$_.Name -like ('*{0}*' -f $Name)}
		} elseif ($All) {
			$method = 'GET'
			$uri = ('{0}/project/' -f $SETTINGS.API.Uri)
			$requestResult = Invoke-APIRequest -Method $method -Uri $uri -Session $Session
		}
		if ($requestResult -ne $null) {
			$output = @()
			foreach ($obj in $requestResult) {
				$output += New-JIRAProject -Uri $obj.self
			}
			$output
		} else {
			throw 'No result for request'
		}
	}
	End {}
}