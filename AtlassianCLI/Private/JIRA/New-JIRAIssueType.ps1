function New-JIRAIssueType {
	<#
		.SYNOPSIS
			Creates a JIRAIssueType objects.

		.DESCRIPTION
			The New-JIRAIssueType cmdlet creates a JIRAIssueType object based on specified input.
		
		.PARAMETER Uri
			Specifies the url to be used to retrieve the JIRAIssueType object.
		
		.PARAMETER Key
			Specifies the key to be used to retrieve the JIRAIssueType object.

		.PARAMETER Session
			Specifies the AtlassianSession to use to perform this task.
			If none is specified Get-AtlassianSession is called.
		
		.EXAMPLE
			#ToDo
		
		.INPUTS
			None or System.String
			A JIRAIssueType object is retrieved using the Uri parameter

		.OUTPUTS
			JIRAIssueType
			Returns a JIRAIssueType object.
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
		function Get-JIRAIssueTypeObject {
			Param(
				[Parameter(
					Mandatory = $true
				)][System.String] $Uri
			)
			$method = 'GET'
			Invoke-APIRequest -Method $method -Uri $Uri -Session $Session | %{
					New-Object -TypeName JIRAIssueType -Property @{
						Self = $_.self
						Id = $_.id
						Name = $_.name
						Description = $_.description
						IsSubTask = [System.Boolean]$_.subtask
						AvatarId = $_.avatarId
						IconUrl = $_.iconUrl
					}
				}
		}
	}
	Process{
		if($Uri) {
			$outpuObject = Get-JIRAIssueTypeObject -Uri $Uri
		}
		if($outpuObject){
			$outpuObject
		} else {
			throw 'No result for request'
		}
	}
	End{}
}