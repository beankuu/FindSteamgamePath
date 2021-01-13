#!/usr/bin/env bash
#Get INPUT
manifest_no=$1;
#Check INPUT is number
#https://stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash
re='^[0-9]+$'
if ! [[ $manifest_no =~ $re ]] ; then
   echo "Error: Invalid Input (not a number)" >&2; exit 1
fi

#find main Steam dir by using Reg Query(Windows)
steamdir=$(Reg Query 'HKCU\SOFTWARE\Valve\Steam' | grep SteamPath | xargs | cut -d " " -f3)/steamapps;
#if game is installed in main Steam dir
if [ -f "$steamdir/appmanifest_$manifest_no.acf" ];then 
    wtdir=$steamdir;
#if game is NOT installed in main Steam dir
else
    #fetch list of library folder files located in main Steam dir
    steamdir_list=$(cat $steamdir/libraryfolders.vdf | sed -e '/^\"/d' -e '/^{/d' -e '/^}/d' | tail -n +3 | xargs | awk '{ for (i=1;i<=NF;i+=2) $i="" } 1' | xargs)
    #loop through list and find the correct folder
    for N in $steamdir_list; do
        if [ -f "$N/steamapps/appmanifest_$manifest_no.acf" ];then
            wtdir=$N/steamapps;
            break;
        fi
    done
    if [ -z "$wtdir" ];then
        echo "Error: game not found"; >&2; exit 1
    fi
fi;
echo $wtdir