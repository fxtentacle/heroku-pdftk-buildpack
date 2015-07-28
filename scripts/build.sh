#!/bin/bash

tarball_url=https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk-2.02-src.zip
temp_dir=$(mktemp -d /tmp/compile.XXXXXXXXXX)

echo "Serving files from /tmp on $PORT"
cd /tmp
python -m SimpleHTTPServer $PORT &

cd $temp_dir
echo "Temp dir: $temp_dir"

echo "Downloading $tarball_url"
curl -L $tarball_url > t.zip
unzip t.zip 


(
	cd pdftk-*
	cd pdftk
	make -f Makefile.Debian 

	zip -9r $temp_dir/pdftk.zip $temp_dir/pdftk-*/pdftk
)

while true
do
	sleep 1
	echo "."
done
