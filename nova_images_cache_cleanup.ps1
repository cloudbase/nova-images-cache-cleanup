$ENV:OS_USERNAME="admin"
$ENV:OS_TENANT_NAME="admin"
$ENV:OS_PASSWORD="your_password"
$ENV:OS_AUTH_URL="http://your_host/v2.0/"

$image_cache_path = "C:\OpenStack\Instances\_base"
$instance_name_pattern = "instance-*"

function Get-OpenStackImageIds {
    $out = nova image-list
	if ($LastExitCode -ne 0) {
		throw "nova image-list failed with exit code $LastExitCode."
	}

    $image_ids = @()
    foreach($line in $out) {
        if ($line -Match "\|\s([0-9a-f\-]+)\s\|") {
            $image_ids += $matches[1]
        }
    }
    return $image_ids
}

# Don't delete existing images and images used as base disks for existing instances 
$image_ids = OpenStackImageIds
$parent_paths = (Get-VMHardDiskDrive $instance_name_pattern | Get-VHD).ParentPath

foreach($file in Get-ChildItem $image_cache_path) {   
   $keep_image = $false
    foreach($parent_path in $parent_paths) {
        if($parent_path -eq $file.FullName) {
            $keep_image = $true
        }
    }

    foreach($image_id in $image_ids) {
        if($file.Name.StartsWith($image_id)) {
            $keep_image = $true
        }
    }
    
    if(!$keep_image) {
        Remove-Item $file.FullName
    }
}




