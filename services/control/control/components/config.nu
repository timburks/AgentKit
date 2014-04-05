(load "AgentHTTP")
(load "AgentCrypto")
(load "AgentMongoDB")

(set SITE "control")
(set PASSWORD_SALT SITE)

(if (eq (uname) "Linux")
    (then (set CONTROL-PATH "/home/control"))
    (else (set CONTROL-PATH "/AgentBox")))

(class NSString
 (- (id) md5HashWithSalt:(id) salt is
    (((self dataUsingEncoding:NSUTF8StringEncoding)
      agent_hmacMd5DataWithKey:(salt dataUsingEncoding:NSUTF8StringEncoding))
     agent_hexEncodedString)))
