Custom buildpack that will install pdftk into /app/bin on Heroku. Supports **cedar-14**, **heroku-16**, and **heroku-18**.

# Heroku-18
Since GCJ was dropped, using:
https://launchpad.net/ubuntu/bionic/amd64/gcj-6-jdk/6.4.0-14ubuntu1

which needs:
https://launchpad.net/ubuntu/bionic/amd64/gcj-6/6.4.0-14ubuntu1
https://launchpad.net/ubuntu/bionic/amd64/gcj-6-jre/6.4.0-14ubuntu1
https://launchpad.net/ubuntu/bionic/amd64/gcj-6-jre-headless/6.4.0-14ubuntu1
https://launchpad.net/ubuntu/bionic/amd64/gcj-6-jre-lib/6.4.0-14ubuntu1

https://launchpad.net/ubuntu/bionic/amd64/libgcj-bc/6.4.0-3ubuntu1
https://launchpad.net/ubuntu/bionic/amd64/libgcj17/6.4.0-14ubuntu1
https://launchpad.net/ubuntu/bionic/amd64/libgcj17-dev/6.4.0-14ubuntu1
https://launchpad.net/ubuntu/bionic/amd64/libgcj17-awt/6.4.0-14ubuntu1
https://launchpad.net/ubuntu/bionic/amd64/libgcj-common/1:6.4-3ubuntu1

https://launchpad.net/ubuntu/bionic/amd64/ecj-gcj/3.11.1-2
https://launchpad.net/ubuntu/bionic/amd64/ecj1/3.11.1-2
https://launchpad.net/ubuntu/bionic/amd64/libecj-java/3.16.0-1~18.04
https://launchpad.net/ubuntu/bionic/amd64/libecj-java-gcj/3.11.1-2


# How to use

1. Add this buildpack to your app. 
3. Use /app/bin/pdftk. BTW, the default PATH includes /app/bin, so this might happen automatically.

# How to upgrade PDFTK

Update the tarball_url line in scripts/build.sh

`heroku create`

`heroku config:set BUILDPACK_URL=https://github.com/fxtentacle/heroku-buildpack-apt`

`git push heroku master`

Now you'll have a new Heroku app on the default stack that runs the `scripts/build.sh` script in this buildpack. That script will download the most recent PDFTK source and configure it with default options.

Use `heroku logs -t` to see when compilation is done. It'll start showing dots..

`heroku open`

1. Download the generated pdftk.zip
2. Chmod +x them
3. put them into `bin/$STACK/` into this buildpack. $STACK shall be the name of your stack as given in the Heroku $STACK variable.

`heroku ps:scale web=0` to turn off the dyno.
