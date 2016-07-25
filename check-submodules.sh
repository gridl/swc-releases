#!/bin/bash


check-individual-submodule() {
    echo "CHECKING: $1"
    local tsturl="$2/tree/$3"
    echo " - testing url: $tsturl"
    local res=$(curl -s "$tsturl")
    if test "$res" = '{"error":"Not Found"}' ; then
        echo ' - !!!!!!!!!!! THERE IS A PROBLEM with '"$tsturl"
    else
        echo ' - ok'
    fi
}

# we list all submodules and reformat the list with one submodule per line
cat .gitmodules | awk '
BEGIN {path = url = branch = ""}
$1 == "[submodule" {path = url = branch = ""; next}
$1 == "path" {path = $3}
$1 == "url" {url = $3}
$1 == "branch" {branch = $3}
path != "" && url != "" && branch != "" {
print path " " url " " branch ;
path = url = branch = ""
}
' | while read line ; do
    # we process each generated line
    check-individual-submodule $line
done

