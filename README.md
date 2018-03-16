## Overview

Provides a way to chain the execution of multiple PowerShell scripts by running a single "host" script.

All 2 of the functions you'll find in `functions.ps1`

### Testing
There's a working example in the `.\tests` folder, which you can invoke by running `.\host.ps1`.  
The output will be something like this:  

```
C:\Users\potato\source\ps-execchainer\tests> .\host.ps1
Hey, I'm Client 1
Hey, I'm Client 2
Hey, I'm Client 3
Hey, I'm Client 4
Hey, I'm Client 5 
```

## How to use

You should be able to pick up how this works by running the example in the .\tests folder. if not I’ve tried to explain as best as I could (in my caffeinated state) below.

### Terminology
 - Clients - the scripts which will be members of the execution chain.
 - Host - the script with my functions, this will control the execution of the clients.

### Setting up the clients

On the first line (or somewhere near the top) of each client put:  
`#exchain.runsafter: <previous member>` (where previous member is the script **before** this script)  

if this script is the first member of the chain put "Start" instead, like so:  
`#exchain.runsafter: START`

### Setting up the host

To find the ChainMembers and build the execution stack run `Get-ChainMembers`, its default values for `-Path` 
(the current directory (recursive)) and `-Filter` (all ps1 files) should usually suffice. 

To get the path of the first or next Chain Member run `Get-NextChainMember`

## Notes 

There is no need to assign `Get-ChainMembers` to a variable, it saves the output in Script scoped variables: 

 - $Script:LastChainMember - Last member that was fetched by `Get-NextChainMember`
 - $Script:ExChain - Hashtable which contains the execution stack
 - $Script:ExChainLength - How many Chain Members there are
