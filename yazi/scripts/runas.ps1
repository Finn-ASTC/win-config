param([string[]]$Files)
foreach ($f in $Files) {
    Start-Process -FilePath $f -Verb RunAs
}
