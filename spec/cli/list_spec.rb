require 'spec_helper'
require 'simple_deploy/cli'

describe SimpleDeploy::CLI::List do

  describe 'stacks' do
    before do
      @lister  = mock 'lister'
      @options = { :environment => 'env 1' }

      @lister.stub(:list).and_return("foo bar")
      SimpleDeploy::CLI::Shared.should_receive(:valid_options?).
                                with(:provided => @options,
                                     :required => [:environment])
      Trollop.stub(:options).and_return(@options)
    end

    context 'when passed a stack lister object' do
      it 'lists the stacks' do
        SimpleDeploy::StackLister.should_not_receive(:new)
        subject.should_receive(:puts).with("foo bar")
        subject.stacks :stack_lister => @lister
      end
    end

    context 'when not passed a stack lister object' do
      before do
        SimpleDeploy::StackLister.should_receive(:new).
                                  with(:environment => 'env 1').
                                  and_return(@lister)
      end

      it 'lists the stacks' do
        subject.should_receive(:puts).with("foo bar")
        subject.stacks
      end
    end

  end

end
