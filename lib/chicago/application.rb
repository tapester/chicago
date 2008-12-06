module Thumblemonks
  module Sinatra
    module Application

      # Assumes all CSS is SASS and is referenced as being in a directory named stylesheets
      def catch_all_css(path='/stylesheets')
        get("#{path}/*.css") {sass params["splat"].first.to_sym}
      end

      # When you don't want anything special, but to load a named view
      def get_obvious(name)
        get "/#{name}" do
          title = name.to_s
          haml name.to_sym
        end
      end

    end # Application

    module Object
      def self.forward_sinatra_method(*methods)
        Array(methods).each do |method|
          module_eval <<-EOS
            def #{method}(*args, &b) ::Sinatra.application.#{method}(*args, &b); end
          EOS
        end
      end

      forward_sinatra_method :catch_all_css, :get_obvious
    end # Object
  end # Sinatra
end # Thumblemonks

Sinatra::Application.instance_eval { include Thumblemonks::Sinatra::Application }
Object.instance_eval { include Thumblemonks::Sinatra::Object }
