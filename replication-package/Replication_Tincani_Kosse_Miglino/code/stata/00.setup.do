********************************************************************************
**# Define portable package paths
********************************************************************************

local package "Replication_Tincani_Kosse_Miglino"
local start "`c(pwd)'"
local root ""

forvalues i = 0/10 {
    capture confirm file "code/stata/0.Main.do"
    if !_rc {
        local root "`c(pwd)'"
        continue, break
    }

    capture confirm file "`package'/code/stata/0.Main.do"
    if !_rc {
        local root "`c(pwd)'/`package'"
        continue, break
    }

    quietly cd ..
}

if "`root'" == "" {
    quietly cd "`start'"
    display as error "Could not auto-detect package root. Start Stata from inside or immediately above `package'."
    exit 601
}

quietly cd "`root'"
local root : subinstr local root "\" "/", all

global root "`root'"
global PATH "$root"
global do_files "$root/code/stata"

global confidential "$root/confidential-data-not-for-publication"
global dataRaw "$confidential/raw"
global dataRawPublic "$root/data/raw"
global dataProcessed "$confidential/processed"
global dataTemp "$dataProcessed"
global dataClean "$dataProcessed"

global output "$root/output"
global tables "$output/tables"
global graphs "$output/figures"
global in_text_numbers "$output/in_text_numbers"
global logs "$output/logs"

global ado_root "$do_files/ado_frozen"
global ado_plus "$ado_root/plus"
global ado_personal "$ado_root/personal"

foreach d in "$dataProcessed" "$dataTemp" "$dataClean" "$output" "$tables" "$graphs" "$in_text_numbers" "$logs" {
    capture mkdir "`d'"
}


sysdir set PLUS "$ado_plus"
sysdir set PERSONAL "$ado_personal"