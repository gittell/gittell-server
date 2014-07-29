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
      redirectUri: "https://#{process.env.CHROME_EXTENSION_ID}.chromiumapp.org/provider_cb"
    web:
      clientId: "web"
      redirectUri: "http://localhost:5000/callback.html"

  gittell:
    clientAssetBaseUrl: "#{process.env.GITTELL_CLIENT_ASSET_BASE_URL}"
