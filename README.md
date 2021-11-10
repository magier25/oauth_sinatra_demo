# oauth_sinatra_demo

Demo app with Google OAuth authorization to fetch the user's files list from Google Drive.

## Prerequisites

Ruby language is required to be installed (ie 2.6.5)

## Getting started

You need to create [OAuth 2.0 Client ID](https://console.cloud.google.com/apis/credentials):

* Application Type: `Web application`
* Authorized JavaScript origins: `http://localhost:4567`
* Authorized redirect URIs: `http://localhost:4567/oauth2callback`

The following description explains how to [set up OAuth 2.0](https://support.google.com/cloud/answer/6158849?hl=en).

Copy `.env.example` into `.env` file, then set `CLIENT_ID` and `CLIENT_SECRET` within `.env`.

## How to run

```bash
bundle install
```

then

```bash
ruby google_drive_example.rb
```

App is available under http://locahost:4567
