#!/bin/sh

dirname=errata-by-rfc

# refresh from repo
git pull

# reset all files (a DOCID may have disappeared when errata spam is deleted)
for i in $dirname/rfc*json
do
  echo "[]" > $i
done

# update all files
jq '.[]."doc-id"' $1 | tr -d '"' | sort -n | uniq | while read rfc
do
  num=$(echo $rfc | cut -c4-)
  fn=$dirname/rfc$num.json
  jq "[.[] | select(.\"doc-id\" == \"$rfc\")]" $1 > $fn
  git add $fn || echo "$num already present"
  git commit $fn -m "update rfc$num" || echo "$num unchanged"
done

# write back
git commit $dirname/rfc*json -m "auto update" || echo unchanged
git push || echo "nothing to commit"
