function New-JIRAUser {
	<#
		.SYNOPSIS
			Creates a JIRAUser objects.
		.DESCRIPTION
			The New-JIRAUser cmdlet creates a JIRAUser object based on specified input.
		.PARAMETER Uri
			Specifies the url to be used to retrieve the JIRAUser object.
		.PARAMETER Session
			Specifies the AtlassianSession to use to perform this task.
			If none is specified Get-AtlassianSession is called.
		.EXAMPLE
			C:\PS> New-JIRAUser -Uri '/rest/api/2/user?username=admin' -Session $Session
			Gets the user with user name admin
		.INPUTS
			None or System.String
			A JIRAUser object is retrieved using the Uri parameter
		.OUTPUTS
			JIRAUser
			Returns a JIRAUser object.
		.NOTES
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
		function Get-JIRAUserObject {
			Param(
				[Parameter(
					Mandatory = $true
				)][System.String] $Uri
			)
			$method = 'GET'
			Invoke-APIRequest -Method $method -Uri $Uri -Session $Session | %{
					New-Object -TypeName JIRAUser -Property @{
						Self = $_.self
						Key = $_.key
						Name = $_.name
						DisplayName = $_.displayname
						#AvatarUrls = $_.avatarUrls
						IsActive = [System.Boolean]$_.active
					}
				}
		}
	}
	Process{
		if($Uri) {
			$outpuObject = Get-JIRAUserObject -Uri $Uri
		}
		if($outpuObject){
			$outpuObject
		} else {
			throw 'No result for request'
		}
	}
	End{}
}