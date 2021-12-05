#function to get system description, and check if property is empty

function Get-Hardware {
    $system = Get-WmiObject win32_computersystem
    $description=$system.description
    ""
    Write-Output "System Hardware"
    if ($description -eq $null) { $description = "data unavailable"}
    "Description: $description"
    ""
    }

#function to get OS Name and version, and check if properties are empty
function Get-OS {
    $OS = Get-WmiObject win32_operatingsystem
    $name = $OS.Caption
    if ($name -eq $null) { $name = "Data unavailable"}
    $version = $OS.Version
    if ($version -eq $null) { $version = "Data unavailable"}
    Write-Output "Operating System"
    "Name: $name"
    "Version: $version"
    ""
    } 

#Function to get processor info, checks if properties are empty

function Get-Processor {
    $processor = Get-WmiObject win32_processor
    $description = $processor.description
    if ($description -eq $null) { $description = "Data unavailable"}
    $speed = $processor.MaxClockSpeed
    if ($speed -eq $null) { $speed = "Data unavailable"}
    $cores = $processor.NumberOfCores
    if ($cores -eq $null) { $cores = "Data unavailable"}
    $L1Cache = $processor.L1CacheSize
    if ($L1Cache -eq $null) { $L1Cache = "Data unavailable"}
    $L2Cache = $processor.L2CacheSize
    if ($L2Cache -eq $null) { $L2Cache = "Data unavailable"}
    $L3Cache = $processor.L3CacheSize
    if ($L3Cache -eq $null) { $L3Cache = "Data unavailable"}

    Write-output "Processor Info"
    "Description: $description"
    "Speed: $speed"
    "Number of cores: $cores"
    "L1 Cache Size: $L1Cache"
    "L2 Cache Size: $L2Cache"
    "L3 Cache Size: $L3Cache"
    ""
}

#function to get info on memory modules, iterates over each one
#converts memory size into readable numbers

function Get-Memory {
    "Physical Memory Info"
    $ram = Get-WMIObject win32_physicalmemory 
    $modules=@()
    foreach ($dimm in $ram) {
        $module = new-object psobject -Property @{
            Vendor = $dimm.Manufacturer
            Description = $dimm.Description
            Size_In_GB = $dimm.capacity / 1GB
            Bank = $dimm.BankLabel
            Slot = $dimm.DeviceLocator

        }
        $modules = $modules+$module
        
    }
    $modules | Format-Table Vendor, Description, Size_In_GB, Bank, Slot -AutoSize    
    $system =Get-WMIObject win32_computersystem
    $totalmem=[math]::Round(($system.TotalPhysicalMemory / 1GB),1)
    "Total System Memory: $totalmem GB"      
    ""   

}

#function to get info on physical drives, iterates over each disk, then partition, then logical drive
#converts memory size into readable numbers and calculates percentage of free space

function Get-PhysicalDrives {
    $drives = Get-CimInstance CIM_diskdrive
    $parts=@()
    foreach ($disk in $drives) {
        $partitions = $disk|Get-CimAssociatedInstance -ResultClassName CIM_diskpartition
        foreach ($partition in $partitions) {
        $logicaldisks = $partition | Get-CimAssociatedInstance -ResultClassName CIM_Logicaldisk
            foreach ($logicaldisk in $logicaldisks) {
                $part=new-object -TypeName psobject -property @{
                    Vendor=$disk.Manufacturer
                    Model=$disk.model
                    Size_in_GB = ([math]::Round(($logicaldisk.size /1GB),1))
                    Free_Space_In_GB = ([math]::Round(($logicaldisk.freespace /1GB),1))
                    Percentage_Free = ([math]::Round((($logicaldisk.freespace/$logicaldisk.size)*100)))
            
                    }
                $parts=$parts+$part

        }
    }

}
"Physical Drive info"
$parts | Format-Table Vendor, Model, Size_in_GB, Free_Space_in_GB, Percentage_free -AutoSize
}

#function gets information on network adapters

function Get-NetworkAdapters {
    get-ciminstance win32_networkadapterconfiguration | 
    where-object ipenabled -eq true |
    Add-Member -Membertype AliasProperty -Name DNS_Server -Value DNSServerSearchOrder -PassThru |
    Select-Object Description, Index, IPAddress, IPSubnet, DNSDomain, DNS_Server |
    format-table  -autosize
    }
#function gets info on video card and displatys resoltion in readable format

function Get-VideoCard {
    $video= Get-WmiObject win32_videocontroller 
    $Vendor = $video.adaptercompatibility
    $Description = $video.description
    $X = $video.currenthorizontalresolution
    $Y = $video.currentverticalresolution
    "Video Card Info"
    "Vendor: $vendor"
    "Description: $Description"
    "Current Screen Resolution: $X x $Y"
        
}

#runs all functions to display info

Get-Hardware
Get-OS
Get-Processor
Get-Memory
Get-PhysicalDrives
Get-NetworkAdapters
Get-VideoCard

    

