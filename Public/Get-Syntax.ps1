function Get-Syntax {
    [CmdletBinding()]
    param (
        $Command,

        [switch]
        $Normalise
    )

    $check = Get-Command -Name $Command

    $params = @{
        Name =  if ($check.CommandType -eq 'Alias') {
                    Get-Command -Name $check.Definition
                }
                else {
                    $Command
                }
        Syntax = $true
    }
    if ($Normalise) {
        Get-Command @params
    }
    else {
        (Get-Command @params) -replace '(\s(?=\[)|\s(?=-))', "`r`n "
    }
}