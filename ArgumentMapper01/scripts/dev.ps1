param($project_path)

$ErrorActionPreference = 'SilentlyContinue'

if (!$project_path) {
  $project_path=Resolve-Path -Path "$($PSScriptRoot)\.." | select -ExpandProperty Path 
}

$name='argumentmapper'
$password='ArgumentMapper3000'

docker argumentmapper create argumentmapper
docker kill ${name}-sql
docker rm ${name}-sql

docker run -v "${project_path}:/project" -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=${password}" -p 1433:1433 --name ${name}-sql --network=network -d mcr.microsoft.com/mssql/server:2017-latest

echo "Sleeping for 20 seconds to allow database to start"
Start-Sleep -s 20

echo "Initializing database"
docker exec -it $name-sql  /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "${password}" -i /project/scripts/init-db.sql
