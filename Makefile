all:	errata.json

errata.json:
	git pull
	curl https://www.rfc-editor.org/errata.json -o errata.json.raw --etag-compare errata.json.etag --etag-save errata.json.etag
	jq "sort_by(.errata_id)" errata.json.raw > $@
	git commit -a -m "auto update" && git push && sh ./extract-by-rfc.sh $@
