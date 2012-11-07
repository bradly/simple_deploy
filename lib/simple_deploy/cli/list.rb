require 'trollop'

module SimpleDeploy
  module CLI
    class List

      def stacks(args={})
        opts = Trollop::options do
          version SimpleDeploy::VERSION
          banner <<-EOS

List stacks in an environment

simple_deploy list -e ENVIRONMENT

EOS
          opt :environment, "Set the target environment", :type => :string
          opt :log_level, "Log level:  debug, info, warn, error", :type    => :string,
                                                                  :default => 'info'
          opt :help, "Display Help"
        end

        CLI::Shared.valid_options? :provided => opts,
                                   :required => [:environment]

        @environment  = opts[:environment]
        @stack_lister = args.fetch(:stack_lister) { stack_lister }

        puts stack_lister.list
      end

      private
      def stack_lister
        @stack_lister ||= SimpleDeploy::StackLister.new :environment => @environment
      end

    end

  end
end
