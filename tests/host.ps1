# very dot saucy!
. ..\functions.ps1

Get-ChainMembers
for ($i = 0; $i -lt $Script:ExChainLength; $i++) {
    $Path = Get-NextChainMember
    Invoke-Expression -Command $Path
}