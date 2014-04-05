;; Twitter OAuth info (Access level: Read-only)
(set TWITTER_OAUTH
     (dict vendor:"twitter"
         protocol:"OAuth"
oauth_consumer_key:"cXzllttrw3cH5ZzREk67Sg"
oauth_consumer_secret:"d6l7s21x9UCqM6HIjQom2Gfr9AGTimYEfZwtcwq5A"
oauth_request_token_url:"https://api.twitter.com/oauth/request_token"
oauth_authorize_url:"https://api.twitter.com/oauth/authorize"
oauth_access_token_url:"https://api.twitter.com/oauth/access_token"))

;; https://console.developers.google.com/project
(set GOOGLE_OAUTH
     (dict vendor:"google"
         protocol:"OAuth2"
    client_secret:"Wrq_GVt6YL-cHaWCYiKk_laA"
        client_id:"1041448997079-51hfjnqlh2dae4bivclueba1rs3m039g.apps.googleusercontent.com"
     redirect_uri:"https://alpha.agent.io/accounts/google/oauth2callback"))

;; https://www.dropbox.com/developers/apps
(set DROPBOX_OAUTH
     (dict vendor:"dropbox"
         protocol:"OAuth2"
    client_secret:"eswl3xlskgub0zk" ;; app secret
        client_id:"s36hrcxhompacc3" ;; app key
     redirect_uri:"https://alpha.agent.io/accounts/dropbox/oauth2callback"))

;; https://app.box.com/developers/services
(set BOX_OAUTH
     (dict vendor:"box"
         protocol:"OAuth2"
    client_secret:"0bsqki1ikLvmjMJHzgthMK4Msdy6E9vo" ;; app secret
        client_id:"346i2ly4i5dnvz0s5smnd202jt5m3gfl" ;; app key
     redirect_uri:"https://alpha.agent.io/accounts/box/oauth2callback"))