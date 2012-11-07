require 'stackster'

module SimpleDeploy

  class StackLister

    def initialize(args={})
      @environment = args[:environment]
      @config      = args.fetch(:config) { Config.new.environment @environment }
    end

    def list
      Stackster::StackLister.new(:config => @config).all.sort
    end

  end
end
