(set PASSWORD_SALT "agent.io")

(macro redirect (location)
       `(progn (RESPONSE setStatus:303)
               (RESPONSE setValue:,location forHTTPHeader:"Location")
               "redirecting"))

(macro htmlpage (title *body)
       `(&html class:"no-js" lang:"en"
               (&head (&meta charset:"utf-8")
                      (&meta name:"viewport" content:"width=device-width, initial-scale=1.0")
                      (&meta name:"description" content:"My Agent on the Internet")
                      (&meta name:"author" content:"Agent I/O")
                      (&title ,title)
                      (&link rel:"stylesheet" href:"/foundation-5/css/foundation.min.css")
                      (&script src:"/foundation-5/js/vendor/modernizr.js"))
               (&body ,@*body
                      (&script src:"/foundation-5/js/vendor/jquery.js")
                      (&script src:"/foundation-5/js/foundation.min.js")
                      (&script "$(document).foundation();"))))

(macro authenticate ()
       `(progn (set screen_name nil)
               (set session nil)
               (if (set cookie ((REQUEST cookies) session:))
                   (set mongo (AgentMongoDB new))
                   (mongo connect)
                   (set session (mongo findOne:(dict cookie:cookie) inCollection:"accounts.sessions"))
                   (set screen_name (session username:)))
               session))

(def js-delete (path)
     (+ "$.ajax({url:'" path "',type:'DELETE',success:function(response) {location.reload(true);}}); return false;"))

(def js-post (path arguments)
     (set command (+ "var form = document.createElement('form');"
                     "form.setAttribute('method', 'POST');"
                     "form.setAttribute('action', '" path "');"))
     (arguments each:
                (do (key value)
                    (command appendString:(+ "var field = document.createElement('input');"
                                             "field.setAttribute('name', '" key "');"
                                             "field.setAttribute('value', '" value "');"
                                             "form.appendChild(field);"))))
     (command appendString:"form.submit();")
     (command appendString:"return false;")
     command)

(macro topbar-for-app (appname additional-items)
       `(progn (set available-apps (array (dict name:"ACCOUNTS" path:"/accounts")
                                          (dict name:"CHIEF" path:"/chief")
                                          (dict name:"FILES" path:"/files")
                                          (dict name:"MDM" path:"/mdm")))
               
               (set current-app (available-apps find:(do (app) (eq (app name:) ,appname))))
               
               (unless (defined screen_name) (set screen_name nil))
               (unless (defined searchtext) (set searchtext ""))
               (set mongo (AgentMongoDB new))
               (mongo connect)
               (set account_services (mongo findArray:(dict $query:(dict) $orderby:(dict vendor:1))
                                         inCollection:"accounts.services"))
               (&div class:"contain-to-grid" style:"margin-bottom:20px;"
                     (&nav class:"top-bar" data-topbar:1
                           (&ul class:"title-area"
                                (&li class:"name"
                                     (&h1 (&a href:(current-app path:) (current-app name:))))
                                (&li class:"toggle-topbar menu-icon" (&a href:"#" "Menu")))
                           (&section class:"top-bar-section"
                                     ;;<!-- Right Nav Section -->
                                     (if screen_name
                                         (&ul class:"right"
                                              (&li (&a href:"#" screen_name))
                                              (&li class:"divider")
                                              (&li class:"active" (&a href:"#" "Sign out" onclick:(js-post "/accounts/signout" nil)))))
                                     
                                     ;;<!-- Left Nav Section -->
                                     (if screen_name
                                         (&ul class:"left"
                                              ,additional-items
                                              ((available-apps select:(do (app) (ne (app name:) ,appname))) map:
                                               (do (app)
                                                   (+ (&li class:"divider")
                                                      (&li (&a href:(app path:) (app name:)))))))))))))

(macro mongo-connect ()
       `(progn (unless (defined mongo)
                       (set mongo (AgentMongoDB new))
                       (mongo connect))))

(function html-escape (s)
          ((((s stringByReplacingOccurrencesOfString:"&" withString:"&amp;")
             stringByReplacingOccurrencesOfString:"<" withString:"&lt;")
            stringByReplacingOccurrencesOfString:">" withString:"&gt;")
           stringByReplacingOccurrencesOfString:"\"" withString:"&quot;"))

((set date-formatter
      ((NSDateFormatter alloc) init))
 setDateFormat:"EEEE MMMM d, yyyy")

((set rss-date-formatter
      ((NSDateFormatter alloc) init))
 setDateFormat:"EEE, d MMM yyyy hh:mm:ss ZZZ")

(function oid (string)
          ((AgentBSONObjectID alloc) initWithString:string))

(class NSArray
 (- subarraysOfN:n is
    (set a (array))
    (set current (array))
    (self each:
          (do (item)
              (if (eq (current count) 0)
                  (a << current))
              (current << item)
              (if (eq (current count) n)
                  (set current (array)))))
    a))


