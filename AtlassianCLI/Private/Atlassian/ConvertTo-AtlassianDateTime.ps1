function ConvertTo-AtlassianDateTime {
	<#
		.SYNOPSIS
			Creates a DateTime objects.

		.DESCRIPTION
			The ConvertTo-AtlassianDateTime cmdlet creates a String object based on specified input.
		
		.PARAMETER InputObject
			Specifies the DateTime to be used to retrieve the String object.
		
		.EXAMPLE
			#ToDo
		
		.INPUTS
			System.DateTime
			A String object is retrieved using the InputObject parameter

		.OUTPUTS
			System.String
			Returns a String object.
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
		[System.DateTime] $InputObject
	)
	Begin{
		$DATETIMEFORMAT = $SETTINGS.Atlassian.DateTimeStringFormat
	}
	Process{
		try{
			$InputObject.ToString($DATETIMEFORMAT)
		} catch {
			throw ('{0} can not be converted to String' -f $InputObject)
		}
	}
	End{}
}