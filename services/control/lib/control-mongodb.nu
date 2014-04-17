#!/usr/local/bin/nush

(load "AgentMongoDB")

(class ControlMongoDB is NSObject)

(macro mongo-connect ()
       `(progn (unless (defined mongo)
                       (set mongo (AgentMongoDB new))
                       (mongo connect))))

(def oid (string)
     ((AgentBSONObjectID alloc) initWithString:string))
