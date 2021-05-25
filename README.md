
# Fork me!

[![Maintainers Wanted](https://img.shields.io/badge/maintainers-wanted-red.svg)](https://github.com/pickhardt/maintainers-wanted)

This repo is easily the one that caused me the most grief in 2020/2021.

I'm not quite sure where people get the idea, but this is NOT A HEROKU PRODUCT.
This is one person sharing some scripts in case it's helpful, but with no warranty, no support, and not even a well-defined license.

And, actually, I kind of dislike Heroku's recent behaviour towards small companies (like mine) since they got purchased by Salesforce. 
For example, they limited the free dyno hours that I use to compile this.
And while most people who message me about it are civil, I sadly have to say this:

Please do not send me insults via email or social media.

If your Heroku app doesn't work, that's clearly between you and Heroku.
If this component is not working for your Heroku deployment, 
that's very sad and you should email the Heroku support about it.
And yes, they'll ignore you, like they ignore everyone, including me. 
Because I'm not a Heroku employee.
I'm just a random stranger on the internet.

And should you really be trusting random unsigned and unverifiable binaries from a stranger on the internet for your production deployment?

I'd say your best option is to fork this repo and compile your own binaries.
I'm sure the Heroku support will be happy to assist you with that.


# What is it

Custom buildpack that will install pdftk into /app/bin on Heroku. Supports **cedar-14**, **heroku-16**, **heroku-18**, **heroku-20**.

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
2. Add the libgcj.so.* to your search path: `heroku config:set LD_LIBRARY_PATH=/app/bin`
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
3. put them into `binaries-$STACK/` into this buildpack. $STACK shall be the name of your stack as given in the Heroku $STACK variable.

`heroku ps:scale web=0` to turn off the dyno.
