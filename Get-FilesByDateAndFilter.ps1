function Get-FilesByExactModifiedDate {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path,

        [Parameter(Mandatory=$true)]
        [string]$Filter,

        [Parameter(Mandatory=$true)]
        [datetime]$Date,

        [switch]$Recurse
    )

    if (-not (Test-Path $Path)) {
        throw "The path '$Path' does not exist."
    }

    try {
        $files = Get-ChildItem -Path $Path -Filter $Filter -File -Recurse:$Recurse |
            Where-Object {
                $_.LastWriteTime.Date -eq $Date.Date
            }

        return $files
    }
    catch {
        Write-Error "Error checking files: $_"
        return $null
    }
}



<#
# Check for .txt files modified exactly on April 15, 2025
$targetDate = Get-Date "2025-04-15"
$results = Get-FilesByExactModifiedDate -Path "C:\Logs" -Filter "*.txt" -Date $targetDate -Recurse

$results | Format-Table Name, LastWriteTime, FullName
#>