---
external help file: AtlassianCLI-help.xml
online version: 
schema: 2.0.0
---

# Get-JIRAIssue

## SYNOPSIS
Get one or more JIRAIssue objects.

## SYNTAX

### Key
```
Get-JIRAIssue -Key <String> [-Session <AtlassianSession>]
```

### JQL
```
Get-JIRAIssue -Jql <String> [-Session <AtlassianSession>]
```

## DESCRIPTION
The Get-JIRAIssue cmdlet gets a specified JIRAIssue object or performs a search to get multiple JIRAIssue objects.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-JIRAIssue -Jql 'project=TEST'
```

Gets all issues returned by the JQL filter 'project=TEST' for the currently loaded session.

## PARAMETERS

### -Key
Specifies the key to be used to retrieve the JIRAIssue object(s).

```yaml
Type: String
Parameter Sets: Key
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Jql
Specifies the JQL filter to be used to retrieve the JIRAIssue object(s).

```yaml
Type: String
Parameter Sets: JQL
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Session
Specifies the AtlassianSession to use to perform this task.
If none is specified Get-AtlassianSession is called.

```yaml
Type: AtlassianSession
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: (Get-AtlassianSession)
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### None
You cannot pipe input to this cmdlet.

## OUTPUTS

### JIRAIssue
Returns one or more JIRAIssue objects.

## NOTES

## RELATED LINKS

