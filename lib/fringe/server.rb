module Fringe
  require 'fileutils'
  require 'yaml'
  class BaseController
    attr_accessor :req
    def initialize(req)
      @req = req
    end
  end

  module RouteHelpers
    def get(*args)
      Fringe::Server.add_route(:get, *args)
    end

    def post(*args)
      Fringe::Server.add_route(:post, *args)
    end

    def put(*args)
      Fringe::Server.add_route(:put, *args)
    end

    def delete(*args)
      Fringe::Server.add_route(:delete, *args)
    end
  end

  class Server
    @@app_dir = nil
    @@routes = {
      get: {},
      post: {},
      put: {},
      delete: {}
    }

    def self.initialize(app_dir)
      @@app_dir = app_dir
      FileUtils.mkdir_p(@@app_dir + "/tmp/logs")
      Dir["#{@@app_dir}/config/initializers/*.rb"].each do |file|
        match = file.match(/\/([^\/.]+)\.rb$/)
        if match
          file_name = match[1]
          require("#{@@app_dir}/config/initializers/#{file_name}")
        end
      end
      Dir["#{@@app_dir}/app/models/*.rb"].each do |file|
        match = file.match(/\/([^\/.]+)\.rb$/)
        if match
          file_name = match[1]
          autoload(file_name.camelize.to_sym, file)
        end
      end
      Dir["#{@@app_dir}/app/controllers/*.rb"].each do |file|
        match = file.match(/\/([^\/.]+)\.rb$/)
        if match
          file_name = match[1]
          require("#{@@app_dir}/app/controllers/#{file_name}")
        end
      end

      require("#{@@app_dir}/app/routes")
    end

    def self.add_route(verb, path, klass, action)
      @@routes[verb][path] = [klass, action]
    end

    def self.route_request(verb, path, req)
      response = [404, {"Content-Type" => "text/html"}, ['404']]
      if @@routes[verb]
        @@routes[verb].keys.each do |pattern|
          if path.match(pattern)
            controller = @@routes[verb][pattern]
            STDOUT.puts "[#{Time.now.to_s}]    Processing by \e[1;34m#{controller[0].to_s}\e[0m#\e[1;32m#{controller[1]}\e[0m"
            response = controller[0].new(req).send(controller[1])
          end
        end
      end
      response
    end

    def self.call(env)
      begin
        path = env["REQUEST_PATH"] || env['PATH_INFO']
        verb = env['REQUEST_METHOD']
        req = Rack::Request.new(env)
        STDOUT.puts %{[#{Time.now.to_s}] Started \e[1;34m#{verb}\e[0m \e[1;32m"#{path}"\e[0m for \e[1;31m#{env['REMOTE_ADDR']}\e[0m}
        return route_request(verb.downcase.to_sym, path, req)
      rescue => e
        puts e
        puts e.backtrace
        [500, {"Content-Type" => "text/html"}, [e.message]]
      end
    end
  end
end
