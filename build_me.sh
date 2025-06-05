docker build -t pdftk-buildpack .
mkdir ./binaries-heroku-24
docker run -it --rm -v ./binaries-heroku-24:/output pdftk-buildpack bash -c "cp -r /tmp/output/* /output"
git add binaries-heroku-24/
