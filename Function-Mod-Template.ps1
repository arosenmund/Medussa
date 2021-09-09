<#

.SYNOPSIS

test test

.DESCRIPTION

.EXAMPLE

.INPUTS

.OUTPUTS

.NOTES

.LINK

.COMPONENT

.ROLE

.FUNCTIONALITY

#>

Function Check-Template {
    [cmdletbinding()]

    Param(

        [string]$test

    )

    write-verbose "This is what this is doing"
    $test
}

<#

need to import-module "this script" to use in other scripts.  Also can save as .psm1 file a

and save to the $env:PSmodulePath locations or add a location full of custom modules.  Then

These will load autmatically. 

#>