function Export-AzKeyVaultCertificate {
    [CmdletBinding()]
    param (
        [parameter(Mandatory)]
        [string]
        $VaultName,

        [Parameter(Mandatory)]
        [string]
        $CertName,

        [securestring]
        $Credential,

        [string]
        $ExportPath = $PWD
    )


    $pfxPath = Join-Path -Path $ExportPath -ChildPath ("{0}.pfx" -f $CertName)

    $kvCertificate = Get-AzKeyVaultSecret -VaultName $VaultName -SecretName $CertName

    if (-not $kvCertificate) {
        throw "No Certificate Found in KeyVault."
    }

    $certBytes = [convert]::FromBase64String($kvcerty.SecretValueText)
    $certCollection = [System.Security.Cryptography.X509Certificates.X509Certificate2Collection]::new()
    $certCollection.Import(
        $certbytes,
        $null,
        [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable
    )

    $password = $Credential | ConvertFrom-SecureString -AsPlainText
    $protectedCertBytes = $certCollection.Export(
        [System.Security.Cryptography.X509Certificates.X509ContentType]::Pkcs12,
        $password
    )

    [System.IO.File]::WriteAllBytes($pfxPath, $protectedCertBytes)
}