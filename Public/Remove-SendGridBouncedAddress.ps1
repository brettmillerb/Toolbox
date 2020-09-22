function Remove-SendGridBouncedAddress {
    [CmdletBinding(ConfirmImpact = 'High',
        SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory,
            ValueFromPipelineByPropertyName)]
        [string[]]
        $EmailAddress,

        [string]
        $Token
    )

    begin {
        $headers = @{
            accept        = 'application/json'
            authorization = 'bearer {0}' -f $token
        }
    }

    process {
        foreach ($email in $EmailAddress) {
            if ($PSCmdlet.ShouldProcess("$email", "Removing Bounced Email Address:")) {
                $invokeRestMethodSplat = @{
                    Uri     = 'https://api.sendgrid.com/v3/suppression/bounces/{0}' -f $EmailAddress
                    Headers = $headers
                    Method  = 'Delete'
                }
                $result = Invoke-RestMethod @invokeRestMethodSplat
    
                $result
            }
        }
    }
}