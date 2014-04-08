(load "AgentHTTP")
(load "AgentCrypto")
(load "AgentMongoDB")

(set SITE "control")
(set PASSWORD_SALT "agent.io")
(set CONTROL-PATH "/home/control")

(class NSString
 (- (id) md5HashWithSalt:(id) salt is
    (((self dataUsingEncoding:NSUTF8StringEncoding)
      agent_hmacMd5DataWithKey:(salt dataUsingEncoding:NSUTF8StringEncoding))
     agent_hexEncodedString)))
