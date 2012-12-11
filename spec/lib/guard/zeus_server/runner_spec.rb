require 'spec_helper'
require 'guard/zeus_server/runner'
require 'fakefs/spec_helpers'

describe Guard::ZeusServer::Runner do
  include FakeFS::SpecHelpers
  let(:options) { { :port => 3000, :command => "server" } }
  let(:runner) { Guard::ZeusServer::Runner.new(options) }
  let(:pid_file) { File.expand_path("tmp/pids/zeus_server.pid") }

  before do
    runner.stub :system
    runner.stub :kill
  end

  describe "#start" do
    it "should start zeus server" do
      runner.should_receive(:system).with("zeus server -d -p 3000 --pid #{pid_file}")

      runner.start
    end

    it "should set the pid" do
      command_should_include("--pid #{pid_file}")

      runner.start
    end

    it "should be daemonized" do
      command_should_include("-d")

      runner.start
    end

    it "should let you change the port" do
      options[:port] = 1234
      command_should_include("-p 1234")

      runner.start
    end


  end

  describe "#stop" do
    it "should kill an existing pid" do
      pid = 54444
      FileUtils.mkdir_p File.dirname(pid_file)
      File.open(pid_file, 'w') { |file| file.print pid }

      runner.should_receive(:kill).with("INT", pid)

      runner.stop
    end
  end

  def command_should_include(part)
    runner.should_receive(:system).with do |command|
      command.should match /\ #{part}\b/
    end
  end
end
