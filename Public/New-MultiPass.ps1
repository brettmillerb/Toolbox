function New-Multipass {
    <#
    .SYNOPSIS
    Creates a MultiPass file to encrypt and store credentials.
    
    .DESCRIPTION
    Creates a MultiPass file to encrypt and store credentials for easy retrieval using Get-MultiPass.
    
    .PARAMETER Path
    Specifies the Path to the location to store the credential XML file.
    
    .PARAMETER Name
    Identifying name of the stored credential which can be referenced during retrieval.
    
    .PARAMETER Force
    Switch to force overwrite a file if it already exists in the Path specified.
    
    .EXAMPLE
    New-MultiPass -Path C:\users\korben.dallas\desktop -Name ADAdmin, O365Admin, Other

    .EXAMPLE
    New-MultiPass -Path C:\users\korben.dallas\desktop -Name ADAdmin, O365Admin, Other -Force
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory,
            Position=0,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [string]
        $FileName,

        [Parameter(Mandatory,
                Position=1)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Name,

        [Parameter(Mandatory = $false)]
        [switch]$Force

    )
    
    begin {
        $output = @{}
        $outpath = Join-Path -Path $Path -ChildPath 'MultiPass.xml'
    }
    
    process {
        if ($PSCmdlet.ShouldProcess($path, ("Creating Password Object for $Name"))) {
            foreach ($item in $Name) {
                $output[$item] = Get-Credential -Message "Enter your $item Password"
            }
        }

        "Saving Multipass file to {0}" -f $outpath | Write-Verbose
        [pscustomobject]$output | Export-Clixml -Path $outpath -NoClobber:$(-not $Force)
    }
}