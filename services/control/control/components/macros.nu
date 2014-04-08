;; helpers

((set date-formatter
      ((NSDateFormatter alloc) init))
 setDateFormat:"EEEE MMMM d, yyyy")

((set rss-date-formatter
      ((NSDateFormatter alloc) init))
 setDateFormat:"EEE, d MMM yyyy hh:mm:ss ZZZ")

(macro mongo-connect ()
       `(progn (unless (defined mongo)
                       (set mongo (RadMongoDB new))
                       (mongo connect))))

;; basic site structure

(macro htmlpage (title *body)
       `(progn (REQUEST setContentType:"text/html")
               (unless (defined account) (set account (get-user REQUEST)))
               (&html class:"no-js" lang:"en"
                      (&head (&meta charset:"utf-8")
                             (&meta name:"viewport" content:"width=device-width, initial-scale=1.0")
                             (&meta name:"description" content:"My Agent on the Internet")
                             (&meta name:"keywords" content:"agent,personal")
                             (&meta name:"author" content:"Tim Burks")
                             (&title ,title)
                             (&link rel:"stylesheet" href:"/foundation-5/css/foundation.min.css")
                             (&script src:"/foundation-5/js/vendor/modernizr.js"))
                      (&body ,@*body
                             ;(&div class:"row" (&div class:"large-12 columns" (&hr) "alpha.agent.io"))
                             (&script src:"/foundation-5/js/vendor/jquery.js")
                             (&script src:"/foundation-5/js/foundation.min.js")
                             (&script "$(document).foundation();")))))

(macro navbar (name)
       `(progn
              (if (and (defined account) account)
                  (set apps (mongo findArray:(dict $query:(dict) ;; (dict owner_id:(account _id:))
                                                 $orderby:(dict name:1))
                                inCollection:(+ SITE ".apps"))))
              (&div class:"contain-to-grid" style:"margin-bottom:20px"
                    (&nav class:"top-bar" data-topbar:1
                          (&ul class:"title-area"
                               (&li class:"name" (&h1 (&a href:"/control" "CONTROL")))
                               (&li class:"toggle-topbar menu-icon"
                                    (&a href:"#" (&span "Menu"))))
                          (&section class:"top-bar-section"
                                    (if (defined apps)
                                        (&ul class:"left"
                                             (&li class:"divider")
                                             (&li (&a href:"/control/nginx.conf" "nginx"))
                                             (&li class:"divider")
                                             (&li (&a href:"/control/browse" "mongodb"))
                                             (&li class:"divider")
                                             (&li class:"has-dropdown" (&a href:"#" "apps")
                                                  (&ul class:"dropdown"
                                                       (apps map:
                                                             (do (app)
                                                                 (&li (&a href:(+ "/control/apps/manage/" (app _id:))
                                                                          (app name:)))))
                                                       (&li class:"divider")
                                                       (&li (&a href:"/control/apps/add" "Add an app"))))))
                                    (&ul class:"right"
                                         (if (and (defined account) account)
                                             (then (&& (&li (&a href:"#" "signed in as " (account username:)))
                                                       (&li (&a href:"/accounts" " accounts"))
                                                       (&li (&a href:"/control/restart" " restart"))))
                                             (else (&li href:"/signin" "sign in")))))))))

