function Get-Syntax {
    <#
    .SYNOPSIS
        Get the syntax for a command.
    .DESCRIPTION
        Get the syntax for a command. A wrapper for Get-Command -Syntax.
    #>

    [CmdletBinding()]
    [Alias('synt', 'syntax')]
    param (
        # The name of a command.
        [Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName, ParameterSetName = 'ByName')]
        [String]$Name,

        # A CommandInfo object.
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'FromCommandInfo')]
        [System.Management.Automation.CommandInfo]$CommandInfo,

        # Write syntax in the short format used by Get-Command.
        [Switch]$Short
    )

    begin {
        $commonParams = @(
            [System.Management.Automation.Internal.CommonParameters].GetProperties().Name
            [System.Management.Automation.Internal.ShouldProcessParameters].GetProperties().Name
            [System.Management.Automation.Internal.TransactionParameters].GetProperties().Name
        )
    }

    process {
        $CommandInfo = Get-CommandInfo @psboundparameters
        foreach ($parameterSet in $CommandInfo.ParameterSets) {
            if ($Short) {
                "`n{0} {1}" -f $CommandInfo.Name, $parameterSet
            }
            else {
                $stringBuilder = [System.Text.StringBuilder]::new().AppendFormat('{0} ', $commandInfo.Name)

                $null = foreach ($parameter in $parameterSet.Parameters) {
                    if ($parameter.Name -notin $commonParams) {
                        if (-not $parameter.IsMandatory) {
                            $stringBuilder.Append('[')
                        }

                        if ($parameter.Position -gt [Int32]::MinValue) {
                            $stringBuilder.Append('[')
                        }

                        $stringBuilder.AppendFormat('-{0}', $parameter.Name)

                        if ($parameter.Position -gt [Int32]::MinValue) {
                            $stringBuilder.Append(']')
                        }

                        if ($parameter.ParameterType -ne [Switch]) {
                            $stringBuilder.AppendFormat(' <{0}>', $parameter.ParameterType.Name)
                        }

                        if (-not $parameter.IsMandatory) {
                            $stringBuilder.Append(']')
                        }

                        $stringBuilder.AppendLine().Append(' ' * ($commandInfo.Name.Length + 1))
                    }
                }

                $stringBuilder.AppendLine().ToString()
            }
        }
    }
}