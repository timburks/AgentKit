(load "AgentHTTP")
(load "AgentCrypto")

(def perform (request)
     (set result (NSURLConnection sendSynchronousRequest:request returningResponse:(set responsep (NuReference new)) error:(set errorp (NuReference new))))
     (set string ((NSString alloc) initWithData:result encoding:NSUTF8StringEncoding))
     (puts "#{((responsep value) statusCode)}: #{string}")
     result)

(class NSDictionary
 (- (id) JSONData is
    (NSJSONSerialization dataWithJSONObject:self options:0 error:nil)))

(class NSData
 (- (id) JSONValue is
    (NSJSONSerialization JSONObjectWithData:self options:0 error:nil)))

;; http://docs.rackspace.com/files/api/v1/cf-devguide/content/Overview-d1e70.html

(set USERNAME "timburks")
(set APIKEY "22b123820f68b18e661abb87528abf68")
(set CONTAINER "agent")

(class RSConnection is NSObject
 
 (- getAccessTokenForUsername:username apiKey:apiKey is
    ;; get token and service URLs
    (set AUTHENTICATION_ENDPOINT "https://identity.api.rackspacecloud.com/v2.0")
    (set URL (NSURL URLWithString:(+ AUTHENTICATION_ENDPOINT "/tokens")))
    (set request (NSMutableURLRequest requestWithURL:URL))
    (request setHTTPMethod:"POST")
    (request setValue:"application/json" forHTTPHeaderField:"Accept")
    (request setValue:"application/json" forHTTPHeaderField:"Content-Type")
    (set post (dict auth:(dict "RAX-KSKEY:apiKeyCredentials"
                               (dict username:username
                                       apiKey:apiKey))))
    (request setHTTPBody:(post JSONData))
    request)
 
 (- authenticateWithResult:info is
    (set @token ((info access:) token:))
    (set @authToken (@token id:))
    (set @services (((info access:) serviceCatalog:) select:
                    (do (item) (eq (item name:) "cloudFiles"))))
    (set @endpoints (((@services 0) endpoints:) select:
                     (do (item) (eq (item region:) "DFW"))))
    (set @serviceURL ((@endpoints 0) publicURL:))
    (set @tenantId ((@endpoints 0) tenantId:))
    @authToken)
 
 (- getContainers is
    (set URL (NSURL URLWithString:@serviceURL))
    (set request (NSMutableURLRequest requestWithURL:URL))
    (request setValue:@authToken forHTTPHeaderField:"X-Auth-Token")
    (request setValue:"application/json" forHTTPHeaderField:"Accept")
    request)
 
 (- getContentsOfContainer:container withLimit:limit marker:marker is
    (set query (dict limit:limit marker:marker))
    (set URL (NSURL URLWithString:(+ @serviceURL "/" CONTAINER "?" (query urlQueryString))))
    (set request (NSMutableURLRequest requestWithURL:URL))
    (request setValue:@authToken forHTTPHeaderField:"X-Auth-Token")
    (request setValue:"application/json" forHTTPHeaderField:"Accept")
    request)
 
 (- getDataWithName:name inContainer:container is
    (set URL (NSURL URLWithString:(+ @serviceURL "/" container "/" name)))
    (set request (NSMutableURLRequest requestWithURL:URL))
    (request setValue:@authToken forHTTPHeaderField:"X-Auth-Token")
    (request setHTTPMethod:"GET")
    request)
 
 (- putData:dataToUpload withName:name inContainer:container is
    (set etag ((dataToUpload md5Data) hexEncodedString))
    (set URL (NSURL URLWithString:(+ @serviceURL "/" container "/" name)))
    (set request (NSMutableURLRequest requestWithURL:URL))
    (request setValue:@authToken forHTTPHeaderField:"X-Auth-Token")
    (request setValue:((dataToUpload length) stringValue) forHTTPHeaderField:"Content-Length")
    (request setValue:etag forHTTPHeaderField:"ETag")
    (request setValue:"application/octet-stream" forHTTPHeaderField:"Content-Type")
    (request setHTTPMethod:"PUT")
    (request setHTTPBody:dataToUpload)
    request))


;; get contents of a container
(def getContentsOfContainer (container)
     (set directory (dict))
     (set marker nil)
     (while YES
            (set result (perform (rackspace getContentsOfContainer:container withLimit:500 marker:marker)))
            (if ((result JSONValue) count)
                (then ((result JSONValue) each:
                       (do (file)
                           (directory setObject:file forKey:(file name:))))
                      (set marker (((result JSONValue) lastObject) name:)))
                (else (break))))
     (puts "Number of files in #{container}: #{(directory count)}")
     directory)

(set DEMO NO)
(if DEMO
    
    (set rackspace (RSConnection new))
    (set result (perform (rackspace getAccessTokenForUsername:USERNAME apiKey:APIKEY)))
    (set token (rackspace authenticateWithResult:(result JSONValue)))
    
    ;; get containers
    (if NO
        (set result (perform (rackspace getContainers)))
        (set info ((result JSONValue) description))
        (puts (info description)))
    
    
    (set dir (getContentsOfContainer "agent"))
    (puts (dir description))
    
    ;; upload
    (set dataToUpload (NSData dataWithContentsOfFile:"/Users/tim/Desktop/RenaissanceIcon.png"))
    (set sha1 ((dataToUpload sha1Data) hexEncodedString))
    (set result (perform (rackspace putData:dataToUpload withName:sha1 inContainer:"agent")))
    (puts ((NSString alloc) initWithData:result encoding:NSUTF8StringEncoding))
    
    ;; download
    (set result (perform (rackspace getDataWithName:sha1 inContainer:"agent")))
    (puts (result length))
    
    (puts ((result sha1Data) hexEncodedString)))

