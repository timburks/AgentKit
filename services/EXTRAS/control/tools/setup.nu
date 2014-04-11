(load "components/config")
(load "components/database")
(load "components/nginx")

(prime-nginx)

(set-username-password "admin" "passme")
