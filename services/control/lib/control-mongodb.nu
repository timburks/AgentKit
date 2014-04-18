#!/usr/local/bin/nush

(load "AgentMongoDB")
(load "AgentCrypto")

(set PASSWORD_SALT "agent.io")

(macro mongo-connect ()
       `(progn (unless (defined mongo)
                       (set mongo (AgentMongoDB new))
                       (mongo connect))))

(def oid (string)
     ((AgentBSONObjectID alloc) initWithString:string))

(class NSString
 (- agent_md5HashWithSalt:salt is
    (((self dataUsingEncoding:NSUTF8StringEncoding)
      agent_hmacMd5DataWithKey:(salt dataUsingEncoding:NSUTF8StringEncoding))
     agent_hexEncodedString)))

(class ControlMongoDB is NSObject
 
 (+ createAdminWithUsername:username password:password is
    (set mongo (AgentMongoDB new))
    (mongo connect)
    (mongo insertObject:(dict username:username
                              password:(password agent_md5HashWithSalt:PASSWORD_SALT)
                                secret:((AgentUUID new) stringValue)
                              verified:YES
                                 admin:YES)
         intoCollection:"accounts.users"))

 (+ deleteAdminWithUsername:username is
    (set mongo (AgentMongoDB new))
    (mongo connect)
    (mongo removeWithCondition:(dict username:username) fromCollection:"accounts.users")))

