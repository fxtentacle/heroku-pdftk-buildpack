docker build -t pdftk-buildpack .
mkdir ./binaries-heroku-22
docker run -it --rm -v ./binaries-heroku-22:/output pdftk-buildpack bash -c "cp -r /tmp/output/* /output"
git add binaries-heroku-22/
