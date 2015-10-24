# docker-piwik

Piwik is a full featured PHP MySQL software program that you download and install on your own webserver. At the end of the five minute installation process you will be given a JavaScript code. Simply copy and paste this tag on websites you wish to track and access your analytics reports in real time.

see it's official site for more information: http://piwik.org/

# Mission Statement

> To provide a simple way, setting up the Piwik.

# Using Docker

## Build image

    $ ./build

This will download all dependences Piwik need as well as Piwik's source files.

## Run Piwik

    $ docker run -d -p 80:80 --name piwik micooz/piwik

This will config Piwik automatically and start all services.

Wait for a while and then check out `http://yourhost`.

Then follow the official instructions for further configuration: https://piwik.org/docs/installation/#the-welcome-screen

## Manage Container

To stop or start the application, just:

    $ docker stop/start piwik

# License

MIT
