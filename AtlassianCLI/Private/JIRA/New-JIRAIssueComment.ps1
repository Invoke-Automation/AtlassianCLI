function New-JIRAIssueComment {
	<#
		.SYNOPSIS
			Creates a JIRAIssueComment objects.

		.DESCRIPTION
			The New-JIRAIssueComment cmdlet creates a JIRAIssueComment object based on specified input.
		
		.PARAMETER Uri
			Specifies the url to be used to retrieve the JIRAIssueComment object.
		
		.PARAMETER Key
			Specifies the key to be used to retrieve the JIRAIssueComment object.

		.PARAMETER Session
			Specifies the AtlassianSession to use to perform this task.
			If none is specified Get-AtlassianSession is called.
		
		.EXAMPLE
			#ToDo
		
		.INPUTS
			None or System.String
			A JIRAIssueComment object is retrieved using the Uri parameter

		.OUTPUTS
			JIRAIssueComment
			Returns a JIRAIssueComment object.
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
		function Get-JIRAIssueCommentObject {
			Param(
				[Parameter(
					Mandatory = $true
				)][System.String] $Uri
			)
			$method = 'GET'
			Invoke-APIRequest -Method $method -Uri $Uri -Session $Session | %{
					New-Object -TypeName JIRAIssueComment -Property @{
						Self = $_.self
						Id = $_.id
						Author = $_.author.self | New-JIRAUser
						UpdateAuthor = $_.updateAuthor.self | New-JIRAUser
						Body = $_.body
						Created = $_.created | ConvertFrom-AtlassianDateTime
						Updated = $_.updated | ConvertFrom-AtlassianDateTime
					}
				}
		}
	}
	Process{
		if($Uri) {
			$outpuObject = Get-JIRAIssueCommentObject -Uri $Uri
		}
		if($outpuObject){
			$outpuObject
		} else {
			throw 'No result for request'
		}
	}
	End{}
}