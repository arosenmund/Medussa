
function Update-ShareRepoValkyrie{

robocopy E:\A_WORKBENCH\ \\BR-R01\Share\Aaron\A_WORKBENCH\ /s /Z /MIR

}

Function UPdate-LocalRepoValkyrie{
robocopy  \\BR-R01\Share\Aaron\A_WORKBENCH\ E:\A_WORKBENCH\ /s /Z /MIR

}

Function Update-LocalRepoOdin{

robocopy \\BR-R01\Share\Aaron\A_Workbench\ F:\A_Workbench\ /s /Z /MIR

}

Function Update-ShareRepoOdin{

robocopy F:\A_Workbench\ \\BR-R01\Share\Aaron\A_Workbench\ /s /Z /MIR

}

