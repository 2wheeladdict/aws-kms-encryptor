<# kms-encrypt.ps1 #>

param (
    [Parameter(Mandatory=$true)][string] $keyId = "",
    [Parameter(Mandatory=$true)][string] $plainText = "",
    [Parameter(Mandatory=$true)][string] $awsProfile = ""
)

###################################
### SETUP VARIABLES              ##
###################################
$ErrorActionPreference = "Stop"
$executionPath = Split-Path -parent $PSCommandPath
$date = Get-Date
$datestring = Get-Date($date) -format yyyyMMddhhmmss
$logDir = "$executionPath\logs"
$logFile = "$logDir\finexus-encryptor.$datestring.log"
$outputDir = "$executionPath\output"

# create log directory, if it doesn't exist
if (!(Test-Path $logDir -PathType Container)) {
    New-Item -ItemType Directory -Force -Path $logDir | Out-Null
}

# create output directory, if it doesn't exist
if (!(Test-Path $outputDir -PathType Container)) {
    New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
}

Function Log {
    Param ([string]$msg = "", [string]$color = "magenta")
    Write-Host -ForegroundColor "$color" $msg;
    $msg | Out-File $logFile -append;
}

Log "---------------------------------------------------------------------"
Log "$(Get-Date -format 'u') :: Finexus Encryptor                         "
Log "---------------------------------------------------------------------"

Log "Starting Encryption (Run ID: $datestring)...`r`n"

$kmsCmd = "aws kms encrypt --key-id ""$keyId"" --plaintext ""$plainText"" --query CiphertextBlob --output text --profile $awsProfile > $outputDir\encrypted-$datestring.txt"
Invoke-Expression $kmsCmd

Log " => Encrypted string $plainText`r`n"
Log "Ciphertext available in $outputDir\encrypted-$datestring.txt" -color "cyan"

# Complete
Log "---------------------------------------------------------------------" "green"
Log "$(Get-Date -format 'u') :: Complete!" "green"
Log "---------------------------------------------------------------------" "green"