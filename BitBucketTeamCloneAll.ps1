$urlBase = "https://api.bitbucket.org/2.0"
$team = "<team name>"
$apiUser = "<bitbucket api user name>"
$apiPass = "<bitbucket api password>"
$authHeader = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $apiUser,$apiPass)))
$bitBucketUser = "<user>"
$bitBucketPass = "<password>"
$backupDir = "c:\bitbucket\backup"

function clone-repo(){
    param([object] $repotToClone)
    
    if ($repo.scm -eq "git"){
        $gitclone = "git clone https://{0}:{1}@bitbucket.org/{2} -q" -f $bitBucketUser, $bitBucketPass, $repo.full_name
        iex $gitclone
    }
    if ($repo.scm -eq "hg"){
        $hgclone = "hg clone https://{0}:{1}@bitbucket.org/{2}" -f $bitBucketUser, $bitBucketPass, $repo.full_name
        iex $hgclone
    }
}

Clear-Host
set-location $backupDir

#trial and error (and Fiddler) show that using -Credential option does not send the auth header.  the server does not challege back, so manually send the header on the first request
$repositories = Invoke-RestMethod ("{0}/repositories/{1}" -f $urlBase, $team) -Method Get -ContentType "application/json" -Headers @{Authorization=("Basic {0}" -f $authHeader)}
while ($repositories){
    for($i=0;$i -lt $repositories.pagelen;$i++){
        $repo = $repositories.values[$i]
        if ($repo.full_name){
            "Start Clone {0}" -f $repo.full_name
            clone-repo -repotToClone $repo
            "Finished Clone {0}" -f $repo.full_name
        }
    }

    if ($repositories.next){
        $repositories = Invoke-RestMethod $repositories.next -Method Get -ContentType "application/json" -Headers @{Authorization=("Basic {0}" -f $authHeader)}
    }
    else{
        $repositories = $null;
    }
}