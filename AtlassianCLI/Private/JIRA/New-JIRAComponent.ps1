function New-JIRAComponent {
	<#
		.SYNOPSIS
			Creates a JIRAComponent objects.
		.DESCRIPTION
			The New-JIRAComponent cmdlet creates a JIRAComponent object based on specified input.
		.PARAMETER Uri
			Specifies the url to be used to retrieve the JIRAComponent object.
		.PARAMETER Session
			Specifies the AtlassianSession to use to perform this task.
			If none is specified Get-AtlassianSession is called.
		.EXAMPLE
			C:\PS> New-JIRAComponent -Uri '/rest/api/2/component/10000' -Session $Session
			Gets the component with id 10000
		.INPUTS
			None or System.String
			A JIRAComponent object is retrieved using the Uri parameter
		.OUTPUTS
			JIRAComponent
			Returns a JIRAComponent object.
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
		function Get-JIRAComponentObject {
			Param(
				[Parameter(
					Mandatory = $true
				)][System.String] $Uri
			)
			$method = 'GET'
			Invoke-APIRequest -Method $method -Uri $Uri -Session $Session | % {
				New-Object -TypeName JIRAComponent -Property @{
					Self                = $_.self
					Id                  = $_.id
					Name                = $_.name
					Description         = $_.description
					IsAssigneeTypeValid = [System.Boolean]$_.isAssigneeTypeValid
				}
			}
		}
	}
	Process {
		if ($Uri) {
			$outpuObject = Get-JIRAComponentObject -Uri $Uri
		}
		if ($outpuObject) {
			$outpuObject
		} else {
			throw 'No result for request'
		}
	}
	End {}
}