class AtlassianObject {
	[System.String] $Self
}

class JIRAComponent : AtlassianObject {
	[System.String] $Id
	[System.String] $Name
	[System.String] $Description

	[System.Nullable[System.Boolean]] $IsAssigneeTypeValid

	[System.String] ToString(){
		return $this.Name
	}
}
class JIRAIssueType : AtlassianObject {
	[System.String] $Id
	[System.String] $Name
	[System.String] $Description
	[System.Nullable[System.Boolean]] $IsSubTask

	[System.String] $AvatarId
	[System.String] $IconUrl

	[System.String] ToString(){
		return $this.Name
	}
}
class JIRAUser : AtlassianObject {
	[System.String] $Key
	[System.String] $Name
	[System.String] $DisplayName

	[System.Nullable[System.Boolean]] $IsActive
	#[System.String[]] $AvatarUrls

	[System.String] ToString(){
		return ('{0} ({1})' -f $this.DisplayName,$this.Name)
	}
}
class JIRAVersion : AtlassianObject {
	[System.String] $Id
	[System.String] $Name
	[System.String] $Description

	[System.Boolean] $IsArchived
	[System.String] $IsReleased

	[System.Nullable[System.DateTime]] $StartDate
	[System.Nullable[System.DateTime]] $ReleaseDate
	[System.Nullable[System.DateTime]] $UserStartDate
	[System.Nullable[System.DateTime]] $UserReleaseDate

	[System.String] $ProjectId

	[System.String] ToString(){
		return $this.Name
	}
}

class JIRAProject : AtlassianObject {
	[System.String] $Id
	[System.String] $Key
	[System.String] $Name
	[System.String] $Description
	[JIRAUser] $Lead
	[JIRAComponent[]] $Components
	[JIRAIssueType[]] $IssueTypes
	[JIRAVersion[]] $Versions
	[System.Collections.Hashtable] $Roles
	[System.String] $Type

	[System.String] ToString(){
		return ('{0} ({1})' -f $this.Name,$this.Key)
	}
}

class JIRAIssue : AtlassianObject {
	[System.String] $Id
	[System.String] $Key

	[JIRAProject] $Project
	[JIRAIssueType] $IssueType
	[JIRAVersion[]] $Versions
	[JIRAVersion[]] $FixVersions
	[JIRAComponent[]] $Components
	[JIRAUser] $Creator
	[JIRAUser] $Reporter
	[JIRAUser] $Assignee
	[JIRAUser[]] $Watchers
	[JIRAUser[]] $Voters
	[JIRAIssueWorklog[]] $WorkLog
	[JIRAIssueComment[]] $Comments
	[JIRAIssue[]] $SubTasks
	[System.Nullable[TimeSpan]] $TimeSpent
	[System.Nullable[TimeSpan]] $TotalTimeSpent
	[System.Nullable[TimeSpan]] $RemainingEstimate
	[System.String] $Status
	[System.String] $Priority
	[System.String] $Flagged
	[System.String] $Sprint

	[System.Collections.Hashtable] $Fields

	[System.String] ToString(){
		return ('{0} ({1})' -f $this.Name,$this.Key)
	}
}

class JIRAIssueWorklog : AtlassianObject {
	[System.String] $Id
	[System.String] $IssueId
	[JIRAUser] $Author
	[JIRAUser] $UpdateAuthor
	[System.String] $Comment
	[System.Nullable[System.DateTime]] $Created
	[System.Nullable[System.DateTime]] $Updated
	[System.Nullable[System.DateTime]] $Started
	[System.Nullable[TimeSpan]] $TimeSpent

	[System.String] ToString(){
		return ("{0}: {1} ({2:HH\:mm\:ss})" -f $this.Author.DisplayName,$this.Comment,$this.TimeSpent)
	}
}
class JIRAIssueComment : AtlassianObject {
	[System.String] $Id
	[JIRAUser] $Author
	[JIRAUser] $UpdateAuthor
	[System.String] $Body
	[System.Nullable[System.DateTime]] $Created
	[System.Nullable[System.DateTime]] $Updated

	[System.String] ToString(){
		return ("{0}: {1}" -f $this.Author.DisplayName,$this.Body)
	}
}

class AtlassianSession {
	hidden [System.String] $DefaultFileExtension = '.enc.xml'
	hidden [System.String] $DefaultFileBaseName = 'AtlassianSession'
	hidden [System.String] $DefaultFileName = ('{0}{1}' -f $this.DefaultFileBaseName,$this.DefaultFileExtension)
	
	[System.String] $Server
	[System.Management.Automation.PSCredential] $Credential

	[System.String] ToString() {
		return ('{0} ({1})' -f $this.Server,$this.Credential.UserName)
	}

	[System.IO.FileInfo] Save() {
		return $this.Save($null)
	}
	[System.IO.FileInfo] Save([System.String]$Path) {
		return $this.Save($Path,$false)
	}
	[System.IO.FileInfo] Save([System.String]$Path,[System.Boolean]$Force) {
		# Check Session
		if(-not ($this.Server -and $this.Credential)){
			Throw "Something Wrong with your Session"
		}

		# Check Path
		if([String]::IsNullOrEmpty($Path)){
			Write-Warning "Empty path.`nDefault values will be used."
			$Path = $this.DefaultFileName
		} else {
			if(Test-Path -Path $Path){
				# The path exists
				if(Test-Path $Path -PathType Container){
					# The path is a folder
					Write-Warning "Path targets a folder.`nDefault file name values will be used."
					$Path = Join-Path $Path $this.DefaultFileName
				} else {
					# The path is a file
					if(-not ((Get-Item -Path $Path).Name).EndsWith($this.DefaultFileExtension)){
						# The file does not have the correct extension
						Write-Warning ('File should use {0} as extension.`nDefault extension will be used.' -f $this.DefaultFileExtension)
						$name = (Get-Item $Path).Name
						if($name.IndexOf('.') -ge 0){
							$Path = Join-Path (Split-Path $Path) (($name.Substring(0,$name.IndexOf('.'))) + $this.DefaultFileExtension)
						} else {
							$Path = Join-Path (Split-Path $Path) ($name + $this.DefaultFileExtension)
						}
						if(-not $Force){
							# The file should not be overwritten
							throw "File already exists.`nUse the Force switch to overwrite an existing file."
						}
					}
				}
			} else {
				# The path does not exist
				if(-not (Split-Path -Path $Path -Leaf).EndsWith($this.DefaultFileExtension)){
					# The file does not have the correct extension
					Write-Warning ('File should use {0} as extension.`nDefault extension will be used.' -f $this.DefaultFileExtension)
					$name = (Split-Path -Path $Path -Leaf)
					if($name.IndexOf('.') -ge 0){
						$Path = Join-Path (Split-Path $Path) (($name.Substring(0,$name.IndexOf('.'))) + $this.DefaultFileExtension)
					} else {
						$Path = Join-Path (Split-Path $Path) ($name + $this.DefaultFileExtension)
					}
				}
			}
		}
		
		# Create temporary object to be serialized to disk
		$export = "" | Select-Object Server, Username, EncryptedPassword

		# Give object a type name which can be identified later
		$export.PSObject.TypeNames.Insert(0,'ExportedAtlassianSession')
		$export.Server = $this.Session.Server
		$export.Username = $this.Session.Credential.Username

		# Encrypt SecureString password using Data Protection API
		# Only the current user account can decrypt this cipher
		$export.EncryptedPassword = $this.Session.Credential.Password | ConvertFrom-SecureString

		# Export using the Export-Clixml cmdlet
		$export | Export-Clixml $Path -Force:$Force

		# Return FileInfo object referring to saved credentials
		return Get-Item $Path
	}
}