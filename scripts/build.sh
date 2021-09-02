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

echo "Patching GCJ to work"
cp /app/.apt/usr/bin/gcj-6 /app/.apt/usr/bin/gcj-6-orig 
sed -i.bak s/\\/usr\\/share\\/java\\/libgcj-6.4.0.jar/~usr\\/share\\/java\\/libgcj-6.4.0.jar/g /app/.apt/usr/bin/gcj-6

cp /app/.apt/usr/bin/../lib/gcc/x86_64-linux-gnu/6.5.0/ecj1 /app/.apt/usr/bin/../lib/gcc/x86_64-linux-gnu/6.5.0/ecj1-orig
sed -i.bak s/\\/usr\\/share\\/java/~usr\\/share\\/java/g /app/.apt/usr/bin/../lib/gcc/x86_64-linux-gnu/6.5.0/ecj1


echo "Compiling"
(
	cd pdftk-*
	cd java
	ln -s /app/.apt/usr/ ~usr
	cd ..
	cd pdftk
	ln -s /app/.apt/usr/ ~usr
	
  sed -i.bak s/\\/usr\\/lib/~usr\\/lib/g ./~usr/lib/x86_64-linux-gnu/libm.so
  sed -i.bak s/\\/usr\\/lib/~usr\\/lib/g ./~usr/lib/x86_64-linux-gnu/libc.so
	
	sed -i.bak s/VERSUFF=-4.6/VERSUFF=-6/g Makefile.Debian 
	sed -i.bak s/\\/usr\\/share\\/java/~usr\\/share\\/java/g Makefile.Debian 
	sed -i.bak "s/CXXFLAGS=/CXXFLAGS= -I\\/app\\/.apt\\/usr\\/include\\/c++\\/6\\/ -idirafter\\/app\\/.apt\\/usr\\/include -I\\/app\\/.apt\\/usr\\/include\\/x86_64-linux-gnu /g" Makefile.Debian 
	
	export CPATH=/app/.apt/usr/include/c++/6:`pwd`/../java
	export LD_LIBRARY_PATH=/app/.apt/usr/lib:/app/.apt/usr/lib/x86_64-linux-gnu
	
	make -f Makefile.Debian 

	zip -9 /tmp/pdftk.zip `pwd`/pdftk /app/.apt/usr/lib/x86_64-linux-gnu/libgcj.so.17
)

while true
do
	sleep 1
	echo "."
done
