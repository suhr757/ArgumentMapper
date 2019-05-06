
param (
   [Parameter(Mandatory=$true)][string]$environment,
   [Parameter(Mandatory=$true)][string]$dbname,
   [Parameter(Mandatory=$true)][string]$flyway_command,
   $project_path
)

$local_project_path=Resolve-Path -Path "$($PSScriptRoot)\.." | select -ExpandProperty Path 

if (!$project_path) {
  $project_path=$local_project_path
}

$image='boxfuse/flyway'

docker pull $image

if ($environment -eq "local") {
  [xml]$config= get-content $local_project_path\scripts\DBConfig_Local.xml
} else {
  [xml]$config= get-content $HOME\flyway\DBConfig_ArgumentMapper_${environment}_${dbname}.xml
}

Push-Location $PSScriptRoot

$db_url=$config.config.url
$db_user=$config.config.user
$db_password=$config.config.password

$cmd="docker run --rm -v ${project_path}/db:/flyway/sql --network=network '$image' -url='$db_url' -user=$db_user -password=$db_password -'placeholders.appuser'=network_${dbname}_user $flyway_command"

Invoke-Expression $cmd

echo $cmd

Pop-Location
