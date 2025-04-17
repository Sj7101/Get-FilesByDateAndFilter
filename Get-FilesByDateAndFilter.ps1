function Get-RemoteMatchingFilesByDate {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$Servers,

        [Parameter(Mandatory = $true)]
        [string]$RemotePath,

        [Parameter(Mandatory = $true)]
        [string[]]$FileNames,

        [Parameter(Mandatory = $true)]
        [datetime]$Date
    )

    $results = @()

    foreach ($server in $Servers) {
        Write-Host "Checking $server..." -ForegroundColor Cyan

        try {
            $serverResult = Invoke-Command -ComputerName $server -ScriptBlock {
                param ($Path, $Names, $TargetDate)
                
                $matched = @()
                foreach ($name in $Names) {
                    $filePath = Join-Path -Path $Path -ChildPath $name
                    if (Test-Path $filePath) {
                        $file = Get-Item $filePath
                        if ($file.LastWriteTime.Date -eq $TargetDate.Date) {
                            $matched += [PSCustomObject]@{
                                Server        = $env:COMPUTERNAME
                                Name          = $file.Name
                                LastWriteTime = $file.LastWriteTime
                                FullName      = $file.FullName
                            }
                        }
                    }
                }
                return $matched
            } -ArgumentList $RemotePath, $FileNames, $Date -ErrorAction Stop

            $results += $serverResult
        }
        catch {
            Write-Warning "Failed to query $server: $_"
        }
    }

    return $results
}





<#
# Load server names from a file
$servers = Get-Content -Path "C:\Path\To\servers.txt"

# Define shared values
$fileList = @("log1.txt", "errors.log", "metrics.csv")
$remotePath = "D:\Logs"
$targetDate = Get-Date "2025-04-15"

# Call the function
$matchedFiles = Get-RemoteMatchingFilesByDate -Servers $servers -RemotePath $remotePath -FileNames $fileList -Date $targetDate

# Output
$matchedFiles | Format-Table Server, Name, LastWriteTime, FullName


#>