(load "AgentJSON")
(load "AgentHTTP")

(task "zip" is
      (SH "mkdir -p build/#{(APP name:)}.app")
      (((NSFileManager defaultManager) contentsOfDirectoryAtPath:"." error:nil) each:
       (do (file)
           (unless (or (/^build$/ findInString:file)
                       (/^Nukefile$/ findInString:file)
                       (/^test$/ findInString:file))
                   (SH "cp -r #{file} build/#{(APP name:)}.app"))))
      (SH "cd build; zip -r #{(APP name:)}.zip #{(APP name:)}.app"))

(task "deploy" => "zip" "list" is
      (set app (APPS find:(do (app) (eq (app name:) (APP name:)))))
      (if app
          (then
               ;; upload a new app version
               (set command (+ "curl -s "
                               AGENT "/control/apps/" (app _id:)
                               " -T build/#{(APP name:)}.zip"
                               " -X POST"
                               " -u " CREDENTIALS))
               (puts command)
               (set results (NSData dataWithShellCommand:command))
               (set version ((results propertyListValue) version:))
               
               (puts "app version: #{version}")
               (set command (+ "curl -s "
                               AGENT "/control/apps/" (app _id:) "/" version "/deploy"
                               " -X POST"
                               " -u " CREDENTIALS))
               (set result (NSString stringWithShellCommand:command))
               (puts "deployment result: #{result}"))
          (else (puts "app not found"))))

(task "list" is
      (set command (+ "curl -s "
                      AGENT "/control/apps"
                      " -u " CREDENTIALS))
      (puts command)
      (set results (NSData dataWithShellCommand:command))
      (global APPS ((results propertyListValue) apps:))
      (APPS each:
            (do (APP)
                (puts (+ (APP _id:) " " (APP name:)))))
      (puts (APPS description))
      "OK")

(task "show" => "list" is
      (set app (APPS find:(do (app) (eq (app name:) (APP name:)))))
      (if app
          (then (set command (+ "curl -s "
                                AGENT "/control/apps/" (app _id:)
                                " -X GET"
                                " -u " CREDENTIALS))
                (puts command)
                (set results (NSString stringWithShellCommand:command))
                (puts "apps: #{(results description)}"))
          (else (puts "App not found"))))

(task "stop" => "list" is
      (set app (APPS find:(do (app) (eq (app name:) (APP name:)))))
      (if app
          (then (set command (+ "curl -s "
                                AGENT "/control/apps/" (app _id:) "/stop"
                                " -X POST"
                                " -u " CREDENTIALS))
                (puts command)
                (set results (NSString stringWithShellCommand:command))
                (puts "apps: #{(results description)}"))
          (else (puts "App not found"))))

(task "delete" => "list" is
      (set app (APPS find:(do (app) (eq (app name:) (APP name:)))))
      (if app
          (then (set command (+ "curl -s "
                                AGENT "/control/apps/" (app _id:)
                                " -X DELETE"
                                " -u " CREDENTIALS))
                (puts command)
                (set results (NSString stringWithShellCommand:command))
                (puts "apps: #{(results description)}"))
          (else (puts "App not found"))))

(task "create" is
      (set post (APP agent_urlQueryString))
      (set command (+ "curl -s "
                      " -d \"" post "\""
                      " -X POST"
                      " " AGENT "/control/apps"
                      " -u " CREDENTIALS))
      (puts command)
      (set results (NSString stringWithShellCommand:command))
      (puts "apps: #{(results description)}"))

(task "restart" is
      (set command (+ "curl -s "
                      " -X POST"
                      " " AGENT "/control/nginx/restart"
                      " -u " CREDENTIALS))
      (puts command)
      (set results (NSString stringWithShellCommand:command))
      (puts "apps: #{(results description)}"))

(task "nginx" is
      (set command (+ "curl -s "
                      " -X GET"
                      " " AGENT "/control/nginx"
                      " -u " CREDENTIALS))
      (puts command)
      (set results (NSString stringWithShellCommand:command))
      (puts "apps: #{(results description)}"))

(task "user" is
      (set command (+ "curl -s "
                      " -X GET"
                      " " AGENT "/control/user"
                      " -u " CREDENTIALS))
      (puts command)
      (set results (NSString stringWithShellCommand:command))
      (puts "apps: #{(results description)}"))

(task "default" => "zip")

(task "clean" is
      (system "rm -rf build"))

(task "clobber" => "clean")
