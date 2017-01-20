function New-JIRAProject {
	<#
		.SYNOPSIS
			Creates a JIRAProject objects.

		.DESCRIPTION
			The New-JIRAProject cmdlet creates a JIRAProject object based on specified input.
		
		.PARAMETER Uri
			Specifies the url to be used to retrieve the JIRAProject object.
		
		.PARAMETER Key
			Specifies the key to be used to retrieve the JIRAProject object.

		.PARAMETER Session
			Specifies the AtlassianSession to use to perform this task.
			If none is specified Get-AtlassianSession is called.
		
		.EXAMPLE
			#ToDo
		
		.INPUTS
			None or System.String
			A JIRAProject object is retrieved using the Uri parameter

		.OUTPUTS
			JIRAProject
			Returns one or more JIRAProject objects.
	#>
	[CmdletBinding(
		#SupportsShouldProcess=$true
		DefaultParameterSetName = 'Uri'
	)]
	Param(
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $true,
			ParameterSetName = 'Uri'
		)]
		[System.String] $Uri,
		[Parameter(
			Mandatory = $true,
			ParameterSetName = 'Key'
		)]
		[System.String] $Key,
		[Parameter(
			Mandatory = $false
		)]
		[AtlassianSession] $Session = (Get-AtlassianSession)
	)
	Begin{
		# Helper Functions
		function Get-JIRAProjectObject {
			Param(
				[Parameter(
					Mandatory = $true
				)][System.String] $Uri
			)
			$method = 'GET'
			Invoke-APIRequest -Method $method -Uri $Uri -Session $Session | %{
					$properties = @{
							Self = $_.self
							Id = $_.id
							Key = $_.key
							Name = $_.name
							Description = $_.description
							Type = $_.projectTypeKey
						}
					# Roles
					if($_.roles) {
						$roles = @{}
						foreach($role in ($_.roles | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name)) {
							$roles.Add($role,$_.roles."$role")
						}
						$properties.Add('Roles',$roles)
					} else {
						$properties.Add('Roles',$null)
					}
					# Lead
					if($_.lead) {
						$properties.Add('Lead',(New-JIRAUser -Uri $_.lead.self))
					} else {
						$properties.Add('Lead',$null)
					}
					# Versions
					if($_.versions){
						$properties.Add('Versions',($_.versions | %{New-JIRAVersion -Uri $_.self}))
					} else {
						$properties.Add('Versions',$null)
					}
					# Components
					if($_.components){
						$properties.Add('Components',($_.components | %{New-JIRAComponent -Uri $_.self}))
					} else {
						$properties.Add('Components',$null)
					}
					# IssueTypes
					if($_.issueTypes){
						$properties.Add('IssueTypes',($_.issueTypes | %{New-JIRAIssueType -Uri $_.self}))
					} else {
						$properties.Add('IssueTypes',$null)
					}
					# Create Object
					New-Object -TypeName JIRAProject -Property $properties
				}
		}
		function Get-JIRAProjectUri {
			Param(
				[Parameter(
					Mandatory = $true
				)][System.String] $Key
			)
			('/rest/api/latest/project/{0}' -f $Key)
		}
	}
	Process{
		if($Uri) {
			$outpuObject = Get-JIRAProjectObject -Uri $Uri
		} elseif($Key) {
			$outpuObject = Get-JIRAProjectObject -Uri (Get-JIRAProjectUri -Key $Key)
		}
		if($outpuObject){
			$outpuObject
		} else {
			throw 'No result for request'
		}
	}
	End{}
}