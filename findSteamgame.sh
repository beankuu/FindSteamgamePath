#Get INPUT
MANIFESTNO=$1;
#Check INPUT is number
#https://stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash
re='^[0-9]+$'
if ! [[ $MANIFESTNO =~ $re ]] ; then
   echo "Error: Invalid Input (not a number)" >&2; exit 1
fi

#find main Steam dir by using Reg Query(Windows)
STEAMDIR=$(Reg Query 'HKCU\SOFTWARE\Valve\Steam' | grep SteamPath | xargs | cut -d " " -f3)/steamapps;
#if game is installed in main Steam dir
if [ -f "$STEAMDIR/appmanifest_$MANIFESTNO.acf" ];then 
    WTDIR=$STEAMDIR;
#if game is NOT installed in main Steam dir
else
    #fetch list of library folder files located in main Steam dir
    steamDirLists=$(cat $STEAMDIR/libraryfolders.vdf | sed -e '/^\"/d' -e '/^{/d' -e '/^}/d' | tail -n +3 | xargs | awk '{ for (i=1;i<=NF;i+=2) $i="" } 1' | xargs)
    #loop through list and find the correct folder
    for N in $steamDirLists; do
        if [ -f "$N/steamapps/appmanifest_$MANIFESTNO.acf" ];then
            WTDIR=$N/steamapps;
            break;
        fi
    done
    if [ -z "$WTDIR" ];then
        echo "Error: game not found"; >&2; exit 1
    fi
fi;
echo $WTDIR