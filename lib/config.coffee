module.exports =
  github:
    clientId: process.env.GITHUB_CLIENT_ID
    clientSecret: process.env.GITHUB_CLIENT_SECRET
    redirectUri: process.env.GITHUB_REDIRECT_URI
    authzUrl: "https://github.com/login/oauth/authorize"
    tokenUrl: "https://github.com/login/oauth/access_token"
    userInfoUrl: "https://api.github.com/user"

  oauth2:
    chromeExtension:
      clientId: "chromeExtension"
      redirectUri: "https://eicfidcpmgfjkeeinjfiiackodgdddhl.chromiumapp.org/provider_cb"
