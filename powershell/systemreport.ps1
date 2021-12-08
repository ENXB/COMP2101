param ([switch]$system,
       [switch] $Disks,
       [switch]$Network) 

if ($system) {
    Get-Processor
    Get-OS
    Get-Memory
    Get-VideoCard
    }
elseif ($disks) {
    Get-PhysicalDrives
    }
elseif ($network) {
Get-NetworkAdapters
    }
else {
    
Get-Hardware
Get-OS
Get-Processor
Get-Memory
Get-PhysicalDrives
Get-NetworkAdapters
Get-VideoCard

}    

