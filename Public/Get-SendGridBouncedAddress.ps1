function Get-SendGridBouncedAddress {
    [CmdletBinding()]
    param (
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
            $invokeRestMethodSplat = @{
                Uri     = 'https://api.sendgrid.com/v3/suppression/bounces/{0}' -f $EmailAddress
                Headers = $headers
                Method  = 'Get'
            }

            $result = Invoke-RestMethod @invokeRestMethodSplat

            $result | Select-Object @{name = 'EmailAddress'; expression = {$result.email}}, reason, status
        }
    }
}