require 'spec_helper'
require 'simple_deploy/cli'

describe SimpleDeploy::CLI::Outputs do
  include_context 'cli config'
  include_context 'double stubbed logger'
  include_context 'stubbed stack', :name        => 'mytest',
                                   :environment => 'test'

  before do
    @config_env    = mock 'environment config'
    @options       = { :environment => 'test',
                       :log_level   => 'info',
                       :name        => 'mytest' }
    @data          = [{ 'OutputKey' => 'key1', 'OutputValue' => 'value1' },
                      { 'OutputKey' => 'key2', 'OutputValue' => 'value2' }]
    Trollop.stub :options => @options
    @config_mock.stub(:environments => { 'test' => 'data' })
    SimpleDeploy.stub(:environments).and_return(@config_env)
    @config_env.should_receive(:keys).and_return(['test'])
    @stack_mock.stub(:outputs).and_return(@data)
    @outputs = SimpleDeploy::CLI::Outputs.new
  end

  after do
    SimpleDeploy.release_config
  end

  it "should successfully return the show command with default values" do
    @outputs.should_receive(:puts).with('key1: value1')
    @outputs.should_receive(:puts).with('key2: value2')
    @outputs.show
  end

  it "should successfully return the show command with as_command_args" do
    @options[:as_command_args] = true
    @outputs.should_receive(:print).with('-a key1=value1 ')
    @outputs.should_receive(:print).with('-a key2=value2 ')
    @outputs.should_receive(:puts).with('')
    @outputs.show
  end

end
