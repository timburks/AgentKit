#!/usr/local/bin/nush
(load "AgentCrypto")
(load "AgentHTTP")

(set message (dict to:"tim"
              subject:"hello"
                  now:(NSDate date)
                 body:"How are you?"))

(set credential "linda:123123")
(set authorization (+ "Basic " ((credential dataUsingEncoding:NSUTF8StringEncoding) agent_base64EncodedString)))

(set URL (NSURL URLWithString:"http://alpha.agent.io/messages/inbox"))
(set request (NSMutableURLRequest requestWithURL:URL))
(request setHTTPMethod:"POST")
(request setHTTPBody:(message binaryPropertyListRepresentation))
(request setValue:"application/plist" forHTTPHeaderField:"Content-Type")
(request setValue:authorization forHTTPHeaderField:"Authorization")
(set result (AgentHTTPClient performRequest:request))
(set string (result UTF8String))

(puts string)

