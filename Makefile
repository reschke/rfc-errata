all:	errata.json

errata.json:
	git pull
	curl https://www.rfc-editor.org/errata.json | jq "sort_by(.errata_id)" > $@
	git commit -a -m "auto update" || echo "nothing to commit"
	git push || echo "nothing to push"
	sh ./extract-by-rfc.sh $@
