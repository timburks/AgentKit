(load "AgentHTTP")
(load "AgentJSON")

;; https://developers.digitalocean.com

(class DigitalOcean is NSObject
 ;; internal
 (- init is
    (super init)
    (set @root "https://api.digitalocean.com")
    self)
 (- args is
    (dict client_id:@clientID api_key:@apiKey))
 (- requestForPath:path is
    (NSMutableURLRequest requestWithURL:(NSURL URLWithString:path)))
 ;; public methods
 (- getDomains is
    (self requestForPath:(+ @root "/domains/?" ((self args) agent_urlQueryString))))
 (- getDroplets is
    (self requestForPath:(+ @root "/droplets/?" ((self args) agent_urlQueryString))))
 
 (- getDropletWithID:dropletID is
    (self requestForPath:(+ @root "/droplets/" dropletID "?" ((self args) agent_urlQueryString))))
 
 (- getRegions is
    (self requestForPath:(+ @root "/regions/?" ((self args) agent_urlQueryString))))
 (- getImages is
    (self requestForPath:(+ @root "/images/?" ((self args) agent_urlQueryString))))
 (- getSSHKeys is
    (self requestForPath:(+ @root "/ssh_keys/?" ((self args) agent_urlQueryString))))
 (- getSizes is
    (self requestForPath:(+ @root "/sizes/?" ((self args) agent_urlQueryString))))
 ;; name=
 ;; image_id=
 ;; region_id=
 ;; ssh_key_ids=[,]
 ;; size_id=
 (- createNewDroplet:droplet is
    (droplet addEntriesFromDictionary:(self args))
    (self requestForPath:(+ @root "/droplets/new?" (droplet agent_urlQueryString))))
 
 
 (- destroyDropletWithID:dropletid is
    (self requestForPath:(+ @root "/droplets/" dropletid "/destroy/?" ((self args) agent_urlQueryString))))
 
 ;; name=
 ;; ip_address=
 (- createNewDomain:domain is
    (domain addEntriesFromDictionary:(self args))
    (self requestForPath:(+ @root "/domains/new?" (domain agent_urlQueryString))))
 
 (- destroyDomainWithID:domainid is
    (self requestForPath:(+ @root "/domains/" domainid "/destroy/?" ((self args) agent_urlQueryString))))
 
 )


(if NO
    (set ClientID "SVa8bfo8arLnPHithQytU")
    (set APIKey "332c46e20057829bdc03cbaa601c5214")
    
    (function run (command)
              (puts (command description))
              (set result (NSURLConnection sendSynchronousRequest:command returningResponse:(set responsep (NuReference new)) error:(set errorp (NuReference new))))
              (puts ((result agent_JSONValue) description)))
    
    (set ocean (DigitalOcean new))
    (ocean setClientID:ClientID)
    (ocean setApiKey:APIKey)
    
    (if NO
        (run (ocean getRegions))
        (run (ocean getImages))
        (run (ocean getSSHKeys))
        (run (ocean getSizes)))
    
    (if NO
        (run (ocean createNewDroplet:(dict name:"sample.agent.io"
                                       image_id:600573
                                      region_id:3
                                    ssh_key_ids:24304
                                        size_id:66))))
    ;(run (ocean destroyDropletWithID:341416))
    (run (ocean getDroplets))
    ;(run (ocean destroyDomainWithID:55533))
    ;(run (ocean createNewDomain:(dict name:"sample.agent.io" ip_address:"192.241.225.217")))
    ;(run (ocean getDomains)))
    
    
    )