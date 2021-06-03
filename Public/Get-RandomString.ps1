function Get-RandomString {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateRange(12, [int]::MaxValue)]
        [int]
        $StringLength,
        [int]
        $SpecialCharacters = 4
    )
    process {
        foreach ($randomString in $StringLength) {
            $chars = ((65..90) + (97..122) | ForEach-Object { $_ -as [char]})
            $specialChars = ((33..46) | ForEach-Object { $_ -as [char]})
            $outputString = $chars | Get-Random -Count ($StringLength - $SpecialCharacters)
            $outputString += $SpecialChars | Get-Random -Count $SpecialCharacters
            -join ($outputString | Get-Random -Count $StringLength)
        }
    }
}