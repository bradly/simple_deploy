require 'simple_deploy/notifier/campfire'

module SimpleDeploy
  class Notifier
    def initialize(args)
      @stack_name = args[:stack_name]
      @environment = args[:environment]
      @config = args[:config]
      @logger = @config.logger
      @notifications = @config.notifications
    end

    def send_deployment_complete_message
      message = "Deployment to #{@stack_name} complete."
      attributes = stack.attributes

      if attributes['app_github_url']
        message += " App: #{attributes['app_github_url']}/commits/#{attributes['app']}"
      end

      if attributes['chef_repo_github_url']
        message += " Chef: #{attributes['chef_repo_github_url']}/commits/#{attributes['chef_repo']}"
      end

      send message
    end

    def send(message)
      @notifications.keys.each do |notification|
        case notification
        when 'campfire'
          campfire = Notifier::Campfire.new :stack_name  => @stack_name,
                                            :config      => @config
          campfire.send message
        end
      end
    end

    private

    def stack
      @stack ||= Stackster::Stack.new :environment => @environment,
                                      :name        => @stack_name,
                                      :config      => @config.environment(@environment),
                                      :logger      => @logger
    end

  end
end
