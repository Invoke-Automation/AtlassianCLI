---
external help file: AtlassianCLI-help.xml
online version: 
schema: 2.0.0
---

# Get-AtlassianSession

## SYNOPSIS
Get one or more JIRAIssue objects.

## SYNTAX

```
Get-AtlassianSession [[-Path] <String>] [-NoNewSession] [<CommonParameters>]
```

## DESCRIPTION
The Get-AtlassianSession cmdlet gets the current AtlassianSession loaded in the custom session variable (name specified in settings.xml) or creates a new one if none exists.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-JIRAIssue -Jql 'project=TEST'
```

Gets all issues returned by the JQL filter 'project=TEST' for the currently loaded session.

## PARAMETERS

### -Path
Specifies the path to the encrypted session file to import.
An encrypted session file can only be loaded by the same user account that saved it.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoNewSession
Specifies you do not want to save the AtlassianSession into the custom session variable.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: NoNew

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
You cannot pipe input to this cmdlet.

## OUTPUTS

### JIRAIssue
Returns one or more JIRAIssue objects.

## NOTES
The AtlassianSession object has a Save(\<Path\>) method that can be called to save an encrypted session file to disk.
Encrypted session files can only be used by the same user account.

## RELATED LINKS

