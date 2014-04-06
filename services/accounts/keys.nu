;; Twitter OAuth info (Access level: Read-only)

(set SERVICES
     (array
           (dict vendor:"twitter"
               protocol:"OAuth"
               info_url:""
     oauth_consumer_key:"cXzllttrw3cH5ZzREk67Sg"
  oauth_consumer_secret:"d6l7s21x9UCqM6HIjQom2Gfr9AGTimYEfZwtcwq5A"
oauth_request_token_url:"https://api.twitter.com/oauth/request_token"
    oauth_authorize_url:"https://api.twitter.com/oauth/authorize"
 oauth_access_token_url:"https://api.twitter.com/oauth/access_token")
           
           (dict vendor:"google"
               protocol:"OAuth2"
               info_url:"https://developers.google.com/accounts/docs/OAuth2Login"
          authorize_url:"https://accounts.google.com/o/oauth2/auth"
             access_url:"https://accounts.google.com/o/oauth2/token"
         authorize_args:(dict prompt:"consent"
                               scope:"https://www.googleapis.com/auth/drive openid email")
          client_secret:"Wrq_GVt6YL-cHaWCYiKk_laA"
              client_id:"1041448997079-51hfjnqlh2dae4bivclueba1rs3m039g.apps.googleusercontent.com"
           redirect_uri:"https://alpha.agent.io/accounts/google/oauth2callback")
           
           (dict vendor:"dropbox"
               protocol:"OAuth2"
               info_url:"https://www.dropbox.com/developers/apps"
          authorize_url:"https://www.dropbox.com/1/oauth2/authorize"
             access_url:"https://api.dropbox.com/1/oauth2/token"
          client_secret:"eswl3xlskgub0zk"
              client_id:"s36hrcxhompacc3"
           redirect_uri:"https://alpha.agent.io/accounts/dropbox/oauth2callback")
           
           (dict vendor:"box"
               protocol:"OAuth2"
               info_url:"https://app.box.com/developers/services"
          authorize_url:"https://www.box.com/api/oauth2/authorize"
             access_url:"https://www.box.com/api/oauth2/token"
          client_secret:"0bsqki1ikLvmjMJHzgthMK4Msdy6E9vo"
              client_id:"346i2ly4i5dnvz0s5smnd202jt5m3gfl"
           redirect_uri:"https://alpha.agent.io/accounts/box/oauth2callback")
           
           (dict vendor:"facebook"
               protocol:"OAuth2"
               info_url:"https://developers.facebook.com/docs/facebook-login/manually-build-a-login-flow/"
          authorize_url:"https://www.facebook.com/dialog/oauth"
             access_url:"https://graph.facebook.com/oauth/access_token"
         authorize_args:(dict scope:"email")
          client_secret:"0db63e695126af00e6de9cd3e19f2ffe"
              client_id:"137251419778620"
           redirect_uri:"https://alpha.agent.io/accounts/facebook/oauth2callback")
           
           (dict vendor:"github"
               protocol:"OAuth2"
               info_url:"https://github.com/settings/applications"
          authorize_url:"https://github.com/login/oauth/authorize"
             access_url:"https://github.com/login/oauth/access_token"
         authorize_args:(dict scope:"user")
          client_secret:"defb32b4b5c7e0e7aa672631f4fdae04432dab84"
              client_id:"2de75ca0d8f4950b36c8"
           redirect_uri:"https://alpha.agent.io/accounts/github/oauth2callback")
           
           (dict vendor:"meetup"
               protocol:"OAuth2"
               info_url:"https://secure.meetup.com/meetup_api/oauth_consumers/"
          authorize_url:"https://secure.meetup.com/oauth2/authorize"
             access_url:"https://secure.meetup.com/oauth2/access"
          client_secret:"n04gong18l86nrosvgl1dhrnn6"
              client_id:"81abik891jf3g457pj3vpo9k5d"
           redirect_uri:"https://alpha.agent.io/accounts/meetup/oauth2callback")
           
           (dict vendor:"linkedin"
               protocol:"OAuth2"
               info_url:"https://www.linkedin.com/secure/developer"
          authorize_url:"https://www.linkedin.com/uas/oauth2/authorization"
             access_url:"https://www.linkedin.com/uas/oauth2/accessToken"
          client_secret:"zuNFfCa3l6VicMziJ47YJnHoyGtHmrKtdbcUDVqSeOhiZSpM2UXl7N32BewyP-7P"
              client_id:"Ajk1W5Wvh0RMbeEdyvSEMTLz86x9WchhZUZVM9H0M2rZ6VR2D3k1-oraMMmIZ_2-"
           redirect_uri:"https://alpha.agent.io/accounts/linkedin/oauth2callback")
           
           (dict vendor:"eventbrite"
               protocol:"OAuth2"
               info_url:"http://developer.eventbrite.com/doc/authentication/oauth2/"
          authorize_url:"https://www.eventbrite.com/oauth/authorize"
             access_url:"https://www.eventbrite.com/oauth/token"
          client_secret:"2BMEM6KHOMWMCCP6IICF5KXFYFFVZZMGYVF5H3H7VH23OYFNIN"
              client_id:"F4NV6ZT56I6ONMHQUN"
           redirect_uri:"https://alpha.agent.io/accounts/eventbrite/oauth2callback")))


