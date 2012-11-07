require 'spec_helper'
require 'simple_deploy/stack_lister'

describe SimpleDeploy::StackLister do
  before { @config = stub 'config' }

  describe 'new' do
    it 'accepts a config object' do
      SimpleDeploy::Config.should_not_receive(:new)
      SimpleDeploy::StackLister.new :config => @config,
                                    :environment => 'env 1'
    end

    it 'creates a config object if not passed one' do
      @config.should_receive(:environment).
              with('env 1').
              and_return(@config)
      SimpleDeploy::Config.should_receive(:new).and_return(@config)
      SimpleDeploy::StackLister.new :environment => 'env 1'
    end

  end

  describe 'list' do
    before do
      @stack_lister = mock 'stack lister'

      Stackster::StackLister.should_receive(:new).
                             with(:config => @config).
                             and_return(@stack_lister)
      @stack_lister.stub(:all).and_return(%w[stack_2 stack_1])
    end

    it 'returns the list of stacks' do
      lister = SimpleDeploy::StackLister.new :config => @config,
                                             :environment => 'env 1'
      lister.list.should == %w[stack_1 stack_2]
    end

  end
end
