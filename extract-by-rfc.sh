#!/bin/sh
git pull
jq '.[]."doc-id"' $1 | tr -d '"' | sort -n | uniq | while read rfc
do
  num=$(echo $rfc | cut -c4-)
  fn=errata-by-rfc/rfc$num.json
  jq "[.[] | select(.\"doc-id\" == \"$rfc\")]" $1 > $fn
  git add $fn || echo "$num already present"
  git commit $fn -m "update rfc$num" || echo "$num unchanged"
done
git push || echo "nothing to commit"

