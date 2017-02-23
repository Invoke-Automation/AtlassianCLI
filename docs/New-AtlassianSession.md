---
external help file: AtlassianCLI-help.xml
online version: 
schema: 2.0.0
---

# New-AtlassianSession

## SYNOPSIS
Initialises a new AtlassianSession

## SYNTAX

```
New-AtlassianSession [-Server] <String> [-Credential] <PSCredential> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-AtlassianSession cmdlet creates a new AtlassianSession object.
If no current AtlassianSession is saved in the custom session variable (name specified in settings.xml) the newly created AtlassianSession will be saved in this variable.
If the custom session variable already has a value you will be prompted whether or not you want to replace it.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
New-AtlassianSession -Server 'http://localhost:2990/jira'
```

Creates a new AtlassianSession that connects to the jira test environment running on your localhost.
Credentials will be prompted.

## PARAMETERS

### -Server
Specifies the Server URL to be used for the session.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
Specifies the Credentials to be used for the session.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: (Get-Credential -Message "Enter Atlassian user credentials")
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
You cannot pipe input to this cmdlet.

## OUTPUTS

### AtlassianSession
Returns the newly created AtlassianSession object. (even if it is not saved)

## NOTES
The AtlassianSession object has a Save(\<Path\>) method that can be called to save an encrypted session file to disk.
Encrypted session files can only be used by the same user account.

## RELATED LINKS

