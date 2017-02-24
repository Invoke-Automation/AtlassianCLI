function ConvertFrom-AtlassianDateTime {
	<#
		.SYNOPSIS
			Creates a DateTime objects.
		.DESCRIPTION
			The Convert-AtlassianDateTime cmdlet creates a DateTime object based on specified input.
		.PARAMETER InputObject
			Specifies the string to be used to retrieve the DateTime object.
		.EXAMPLE
			PS C:\> ConvertFrom-AtlassianDateTime -InputObject '2017-02-24T13:26:32.482+01:00'
			Friday, February 24, 2017 13:26:32
		.INPUTS
			System.String
			A DateTime object is retrieved using the Uri parameter
		.OUTPUTS
			DateTime
			Returns a DateTime object.
		.NOTES
	#>
	[CmdletBinding(
		#SupportsShouldProcess=$true
	)]
	Param(
		[Parameter(
			Mandatory = $true,
			Position = 1,
			ValueFromPipeline = $true
		)]
		[System.String] $InputObject
	)
	Begin{
		$DATETIMEPATTERN = $SETTINGS.Atlassian.DateTimeStringPattern
	}
	Process{
		if($InputObject -match $DATETIMEPATTERN){
			try{
				[datetime]::Parse($InputObject)
			} catch {
				throw ('{0} can not be converted to DateTime' -f $InputObject)
			}
		} else {
			throw ('{0} has the wrong format' -f $InputObject)
		}
	}
	End{}
}