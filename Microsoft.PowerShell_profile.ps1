function Docker-ListAllContainers{
    docker ps -a --format "table{{.ID}}\t{{.Names}}\t{{.Image}}\t{{.RunningFor}}\t{{.Status}}"
}
Set-Alias d-ps Docker-ListAllContainers

function Docker-StartMyContainers{
    docker start activemq
    docker start postgres12
}
Set-Alias d-start Docker-StartMyContainers

function Docker-StopMyContainers{
    docker stop activemq
    docker stop postgres12
}
Set-Alias d-stop Docker-StopMyContainers

function git-fetch {
    git fetch -p
}
Set-Alias fetch git-fetch

function git-pull {
    git pull
    git clean -f -d
}
Set-Alias pull git-pull

function localstack-aws {
    docker exec --name aws-cli -it amazon/aws --endpoint-url=http://localhost:4566 $args
}
Set-Alias local-aws localstack-aws

oh-my-posh --init --shell pwsh --config c:\source\matt\scripts\posh-matt.omp.json | Invoke-Expression
