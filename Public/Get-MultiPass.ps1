function Get-MultiPass {
    <#
    .SYNOPSIS
    Retrieves a previously created MultiPass file
    
    .DESCRIPTION
    Retrieves a previously created MultiPass file from the specified Path
    
    .PARAMETER Path
    Specifies a path to the location of a credential XML file.
    
    .EXAMPLE
    Get-MultiPass -Path C:\users\korben.dallas\desktop.multipass.xml
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateScript({Test-Path -Path $_ -PathType Leaf})]
        [String]$Path
    )

    process {
        Try {
            Import-Clixml -Path $Path -ErrorAction Stop
        }
        Catch {
            throw ("Unable to import Multipass File from {0}" -f $Path)
        }
    }
}