require 'spec_helper'
require 'guard/zeus_server'

describe Guard::ZeusServer do
  let(:options) { {} }
  let(:watchers) { [] }
  let(:runner) { stub }
  let(:guard) { Guard::ZeusServer.new(watchers, options) }

  before do
    guard.runner = runner
  end

  it "should have default options" do
    guard.options[:port].should == 3000
    guard.options[:command].should == "server"
  end

  describe "#start" do
    it "should start the runner" do
      runner.should_receive(:start)

      guard.start
    end
  end

  describe "#stop" do
    it "should stop the runner" do
      runner.should_receive(:stop)

      guard.stop
    end
  end

  describe "#reload" do
    it "should stop the runner" do
      runner.should_receive(:restart)

      guard.reload
    end
  end

  describe "#run_all" do
    it "should do nothing" do
      guard.run_all
    end
  end

  describe "#run_on_changes" do
    it "should restart the runner" do
      runner.should_receive(:restart)

      guard.run_on_changes("foo.rb")
    end
  end

  describe "#run_on_removals" do
    it "should restart the runner" do
      runner.should_receive(:restart)

      guard.run_on_removals("foo.rb")
    end
  end
end
