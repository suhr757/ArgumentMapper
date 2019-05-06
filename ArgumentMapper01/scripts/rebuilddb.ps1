
param (
   [Parameter(Mandatory=$true)][string]$environment,
   [Parameter(Mandatory=$true)][string]$dbname,
   $project_path
)

$local_project_path=Resolve-Path -Path "$($PSScriptRoot)\.." | select -ExpandProperty Path 

if (!$project_path) {
  $project_path=$local_project_path
}

if ($environment -eq "local") {
  [xml]$config= get-content $local_project_path\scripts\DBConfig_Local.xml
} else {
  [xml]$config= get-content $HOME\flyway\DBConfig_ArgumentMapper_${environment}_${dbname}.xml
}

Push-Location $PSScriptRoot

$db_server=$config.config.server
$db_database=$config.config.database
$db_url=$config.config.url
$db_user=$config.config.user
$db_password=$config.config.password


.\flyway.ps1 $environment $dbname clean $project_path
.\flyway.ps1 $environment $dbname migrate $project_path



if ($environment -eq "local") {
  $cmd="docker exec -it network-sql /opt/mssql-tools/bin/sqlcmd -S $db_server -U $db_user -P $db_password -d $db_database -i /project/db/insert-test.sql"
} else {
  $cmd="docker run -v '${project_path}:/project' mcr.microsoft.com/mssql-tools /opt/mssql-tools/bin/sqlcmd -S $db_server -U $db_user -P $db_password -d $db_database -i /project/db/insert-test.sql"
}

Invoke-Expression $cmd

echo $cmd

Pop-Location
