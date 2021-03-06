
(macro get-user (REQUEST)
       `(progn (set screen_name nil)
               (set session nil)
               (set user nil)
               (if (set token ((,REQUEST cookies) session:))
                   (set mongo (AgentMongoDB new))
                   (mongo connect)
                   (set session (mongo findOne:(dict cookie:token) inCollection:"accounts.sessions"))
	 	   (if session (then (set user (mongo findOne:(dict _id:(session account_id:)) inCollection:"accounts.users")))
                               (else (set user nil)))
                   (set screen_name (session username:)))
               user))

(macro require-account ()
       (unless (set account (get-user REQUEST)) (return nil)))

(get "/control/whoami"
     (set account (get-user REQUEST))
     (REQUEST setContentType:"text/plain")
     (account description))
