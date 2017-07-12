---
external help file: AtlassianCLI-help.xml
online version: http://docs.invoke-automation.com
schema: 2.0.0
---

# Invoke-APIRequest

## SYNOPSIS
Invokes an API request

## SYNTAX

```
Invoke-APIRequest [-Method] <String> [-Uri] <String> [[-Body] <String>] [-Session] <AtlassianSession>
```

## DESCRIPTION
The Invoke-APIRequest cmdlet creates the authentication headers and passes through all other info to the Invoke-RestMethod.
The output of this Invoke-RestMethod is directly passed through.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Invoke-APIRequest -Method 'POST' -Uri 'rest/api/2/issue/' -Body $requestBody -Session $Session
```

Uses the info in the provided $Session to creates a new issue with the info in the $requestBody

## PARAMETERS

### -Method
Specifies the method to be used to run the Invoke-RestMethod cmdlet.

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

### -Uri
Specifies the uri to be used to run the Invoke-RestMethod cmdlet.
If the uri does not start with http or https it will be appended to the server url from the provided AtlassianSession.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Body
Specifies the body to be used to run the Invoke-RestMethod cmdlet.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Session
Specifies the AtlassianSession to use to create the authentication header.
If none is specified Get-AtlassianSession is called.

```yaml
Type: AtlassianSession
Parameter Sets: (All)
Aliases: 

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### None
You cannot pipe input to this cmdlet.

## OUTPUTS

### System.Xml.XmlDocument, Microsoft.PowerShell.Commands.HtmlWebResponseObject, System.String
The output of the cmdlet depends upon the format of the content that is retrieved.

PSObject
If the request returns JSON strings, Invoke-RestMethod returns a PSObject that represents the strings.

## NOTES

## RELATED LINKS

[http://docs.invoke-automation.com](http://docs.invoke-automation.com)

