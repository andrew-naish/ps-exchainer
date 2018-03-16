function Get-ChainMembers ([string]$Path=".", [string]$Filter="*.ps1") {
    
    $matchPattern = "#exchain\.runsafter: ?(.+)"
    $thisScript = $MyInvocation.ScriptName
    $returnHash = @{}
    
    $search = Get-ChildItem -Recurse -Exclude "$thisScript" -Path "$Path" -Filter "$Filter" | 
        Select-String -Pattern "$matchPattern" 
    
    if (!$search) { 
        throw "No Chain Members found"
    }
    
    [int]$chainLength = 0
    foreach ($result in $search) {
        $returnHash.Add($($result.matches[0].groups[1].value),$($result.path))
        $chainLength++
    }
    
    if ( !$returnHash.start ) { 
        throw "No start node present" 
    } 
    
    # set vars
    $Script:LastChainMember = ""
    $Script:ExChain = $returnHash
    $Script:ExChainLength = $chainLength
	
}

function Get-NextChainMember() {
    
    # the start
    if ( !$Script:LastChainMember ) {
        $rtMember = $Script:ExChain.Start
    } 
    
    # any subsequent invocations
    else {
        $lastLeaf = $Script:LastChainMember | Split-Path -Leaf
        $rtMember = $Script:ExChain.$lastLeaf
    }
    
    $Script:LastChainMember = $rtMember
    return $rtMember
    
}