#!/usr/local/bin/nush
#
# requires control-common
# requires control-mongodb
#

(class ControlNginx is NSObject
 
 (+ nginxConfigurationWithApps:apps is
    
    (if ((NSFileManager defaultManager) fileExistsAtPath:"#{CONTROL_PATH}/etc/agent.key")
        (then (set SSLCONFIG <<-END
        listen          443 ssl;
        ssl_certificate     #{CONTROL_PATH}/etc/agent.crt;
        ssl_certificate_key #{CONTROL_PATH}/etc/agent.key;
END))
        (else (set SSLCONFIG "")))
    
    <<-END
#
# Agent I/O nginx configuration
# this file was automatically generated
#
worker_processes  8;

events {
    worker_connections  1024;
}

http {
    log_format control '$msec|$time_local|$host|$request|$status|$bytes_sent|$request_time|$remote_addr|$http_referer|$http_user_agent|||';
    access_log #{CONTROL_PATH}/var/nginx-access.log control;
    error_log #{CONTROL_PATH}/var/nginx-error.log debug;

    large_client_header_buffers 4 32k;

    gzip on;
    gzip_proxied any;

    types_hash_bucket_size 64;
    types {
        application/x-mpegURL                   m3u8;
        video/MP2T                              ts;
        video/mp4                               mp4;
        application/xml                         xml;
        image/gif                               gif;
        image/jpeg                              jpg;
        image/png                               png;
        image/bmp                               bmp;
        image/x-icon                            ico;
        text/css                                css;
        text/html                               html;
        text/plain                              txt;
        application/pdf                         pdf;
        text/xml                                plist;
        application/octet-stream                dmg;
        application/octet-stream                ipa;
        application/octet-stream                mobileprovision;
        application/x-apple-aspen-config        mobileconfig;
    }
    default_type       text/html;

    server_names_hash_bucket_size 64;
    server_names_hash_max_size 8192;
#{(self upstreamServersForApps:apps)}

    server {
        listen          80;
#{SSLCONFIG}
        server_name     ~^(.*)$;
        root #{CONTROL_PATH}/public;
        try_files $uri.html $uri $uri/ =404;
        error_page 404  /404.html;
        error_page 403  /403.html;
        error_page 502  /502.html;
        location /control/ {
            proxy_set_header Host $host;
            proxy_pass  http://127.0.0.1:2010;
        }
#{(self locationsForApps:apps)}
        client_max_body_size 10M;
    }
#{(self serversForApps:apps)}
}
END)
 
 (+ serversForApps:apps is
    (set RESULTS "")
    (apps each:
          (do (app)
              (if (and (app domains:) ((app domains:) length) (((app deployment:) workers:) count))
                  (then (set server-name (app domains:))
                        (RESULTS << <<-END

    server {
        listen          80;
        server_name     #{server-name};
        root #{CONTROL_PATH}/public;
        try_files $uri.html $uri $uri/ =404;
        error_page 404  /404.html;
        error_page 403  /403.html;
        error_page 502  /502.html;
        location / {
            proxy_set_header Host $host;
            proxy_pass http://#{(app _id:)};
            proxy_set_header X-Forwarded-For $remote_addr;
        }
    }
END)))))
    RESULTS)
 
 (+ locationsForApps:apps is
    (set RESULTS "")
    (apps each:
          (do (app)
              (if (and (app path:) ((app path:) length) (((app deployment:) workers:) count))
                  (then (RESULTS << (+ "        # " (app name:) "\n"
                                       "        location /" (app path:) "/ {\n"
                                       "            proxy_set_header Host $host;\n"
                                       "            proxy_pass http://" (app _id:) ";\n"
                                       "            proxy_set_header X-Forwarded-For $remote_addr;\n"
                                       "        }\n"))))))
    RESULTS)
 
 (+ upstreamServersForApps:apps is
    (set RESULTS "")
    (apps each:
          (do (app)
              (if (((app deployment:) workers:) count)
                  (then (RESULTS << (+ "\n"
                                       "    # " (app name:) "\n"
                                       "    upstream " (app _id:) "{\n"
                                       ((((app deployment:) workers:) map:
                                         (do (worker)
                                             (+ "        server 127.0.0.1:" (worker port:) ";")))
                                        componentsJoinedByString:"\n")
                                       "\n    }"))))))
    RESULTS)
 
 (+ pathForNginxConf is
    "/etc/nginx/nginx.conf")
 
 (+ pathForNginx is
    "/usr/sbin/nginx")
 
 (+ restart is
    (mongo-connect)
    ((NSFileManager defaultManager) removeItemAtPath:(self pathForNginxConf) error:nil)
    (set apps (mongo findArray:nil inCollection:"control.apps"))
    ((self nginxConfigurationWithApps:apps) writeToFile:(self pathForNginxConf) atomically:YES)
    (system "#{(self pathForNginx)} -s reload -c #{(self pathForNginxConf)} -p #{CONTROL_PATH}/nginx/"))
 
 (+ prime is
    ((NSFileManager defaultManager) removeItemAtPath:(self pathForNginxConf) error:nil)
    ((self nginxConfigurationWithApps:(array)) writeToFile:(self pathForNginxConf) atomically:YES)
    ;; control redirect
    ((&a href:(+ "/control") "OK, Continue")
     writeToFile:"#{CONTROL_PATH}/public/restart.html" atomically:NO)
    (system "#{(self pathForNginx)} -c #{(self pathForNginxConf)} -p #{CONTROL_PATH}/nginx/")))
