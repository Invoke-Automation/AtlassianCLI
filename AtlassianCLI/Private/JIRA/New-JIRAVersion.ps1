function New-JIRAVersion {
	<#
		.SYNOPSIS
			Creates a JIRAVersion objects.
		.DESCRIPTION
			The New-JIRAVersion cmdlet creates a JIRAVersion object based on specified input.
		.PARAMETER Uri
			Specifies the url to be used to retrieve the JIRAVersion object.
		.PARAMETER Session
			Specifies the AtlassianSession to use to perform this task.
			If none is specified Get-AtlassianSession is called.
		.EXAMPLE
			C:\PS> New-JIRAVersion -Uri '/rest/api/2/version/10000' -Session $Session
			Gets the version with id 10000
		.INPUTS
			None or System.String
			A JIRAVersion object is retrieved using the Uri parameter
		.OUTPUTS
			JIRAVersion
			Returns a JIRAVersion object.
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
		# Helper Functions
		function Get-JIRAVersionObject {
			Param(
				[Parameter(
					Mandatory = $true
				)][System.String] $Uri
			)
			$method = 'GET'
			Invoke-APIRequest -Method $method -Uri $Uri -Session $Session | % {
				New-Object -TypeName JIRAVersion -Property @{
					Self            = $_.self
					Id              = $_.id
					Name            = $_.name
					Description     = $_.description
					IsArchived      = [System.Boolean]$_.archived
					IsReleased      = [System.Boolean]$_.released
					StartDate       = [System.Nullable[System.DateTime]]$_.startDate
					ReleaseDate     = [System.Nullable[System.DateTime]]$_.releaseDate
					UserStartDate   = [System.Nullable[System.DateTime]]$_.userStartDate
					UserReleaseDate = [System.Nullable[System.DateTime]]$_.userReleaseDate
					ProjectId       = $_.projectId
				}
			}
		}
	}
	Process {
		if ($Uri) {
			$outpuObject = Get-JIRAVersionObject -Uri $Uri
		}
		if ($outpuObject) {
			$outpuObject
		} else {
			throw 'No result for request'
		}
	}
	End {}
}