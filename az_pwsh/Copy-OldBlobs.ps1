# This script uses Az Powershell to copy blobs with a modified date older than the specficied date filter
# to another storage account which can be on the same subscription, or any subscription that you have 
# the keys to. 
#
# This script uses Az Powershell 3.8.0 -- which will work on Windows on PowerShell 
# And on Windows, Mac, and Linux using PowerShell Core
#
# On Windows you can use the built-in PS or... 
# https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-windows?view=powershell-7
#
# Install PowerShell Core on Mac
# https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-macos?view=powershell-7
#
# Install PowerShell Core on Linux
# https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7
#
# Install the AZ Powershell Module 
# https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-3.8.0

# Set your date filter. This is older than 4 days ago. You can change the number to -30, -90 etc. 
$dateFilter = [DateTime]::UtcNow.AddDays(-4)
# Source Blob Account/Container Info
$sourceStorageAccountName = "YOUR_STORAGE_ACCOUNT_NAME";
$sourceContainerName = "YOUR_CONTAINER_NAME";
$sourceStorageAccountKey = "STORAGE_KEY";
# Destination Blob Account/Container info
$destStorageAccountName = "YOUR_STORAGE_ACCOUNT_NAME";
$destContainerName = "YOUR_CONTAINER_NAME";
$destStorageAccountKey = "STORAGE_KEY";

# Set up connection contexts for source and dest. 
$sourceContext = New-AzStorageContext -StorageAccountName $sourceStorageAccountName -StorageAccountKey $sourceStorageAccountKey;
$destContext = New-AzStorageContext -StorageAccountName $destStorageAccountName -StorageAccountKey $destStorageAccountKey;

$blobsToCopy = Get-AzStorageBlob -Container "$sourceContainerName" -Context $sourceContext | Where-Object { $_.LastModified.UtcDateTime -lt $dateFilter } 
foreach($b in $blobsToCopy){
    Start-AzStorageBlobCopy -SrcBlob $b.BlobClient.Name -SrcContainer $sourceContainerName -DestContainer $destContainerName -Context $sourceContext -DestContext $destContext
}
  
  
