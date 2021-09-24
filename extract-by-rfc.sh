#!/bin/sh

dirname=errata-by-rfc

git pull

ls $dirname/rfc*json | cut -d/ -f2 | cut -c 4- | cut -d . -f1 > existing-errata.txt

(cat existing.errata ; jq '.[]."doc-id"' $1 | tr -d '"' ) | sort -n | uniq | while read rfc
do
  num=$(echo $rfc | cut -c4-)
  fn=$dirname/rfc$num.json
  jq "[.[] | select(.\"doc-id\" == \"$rfc\")]" $1 > $fn
  git add $fn || echo "$num already present"
  git commit $fn -m "update rfc$num" || echo "$num unchanged"
done
git push || echo "nothing to commit"

