require 'spec_helper'
require 'simple_deploy/cli'

describe SimpleDeploy::CLI::Environments do

  describe 'environments' do
    before do
      @config   = mock 'config'
      @env_data = { 'env_1' => 'foo',
                    'env_2' => 'bar' }
      SimpleDeploy::Config.stub(:new).and_return(@config)
      @config.stub(:environments).and_return(@env_data)
      Trollop.stub(:options)
    end

    it 'outputs the environments' do
      subject.should_receive(:puts).with('env_1')
      subject.should_receive(:puts).with('env_2')
      subject.environments
    end

  end

end
