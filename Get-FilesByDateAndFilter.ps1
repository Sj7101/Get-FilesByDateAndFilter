function Get-MatchingFilesByDate {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [string[]]$FileNames,

        [Parameter(Mandatory = $true)]
        [datetime]$Date
    )

    if (-not (Test-Path $Path)) {
        throw "The path '$Path' does not exist."
    }

    $matchingFiles = @()

    foreach ($fileName in $FileNames) {
        $fullPath = Join-Path -Path $Path -ChildPath $fileName
        if (Test-Path $fullPath) {
            $file = Get-Item $fullPath
            if ($file.LastWriteTime.Date -eq $Date.Date) {
                $matchingFiles += $file
            }
        }
    }

    return $matchingFiles
}




<#
# Files you're checking
$fileList = @("log1.txt", "report.csv", "errors.log")

# The path and date you want to match
$path = "C:\Logs"
$dateToMatch = Get-Date "2025-04-15"

# Run the function
$results = Get-MatchingFilesByDate -Path $path -FileNames $fileList -Date $dateToMatch

# Output result
$results | Format-Table Name, LastWriteTime, FullName

#>