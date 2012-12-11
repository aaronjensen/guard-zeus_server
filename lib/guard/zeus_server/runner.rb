require 'fileutils'

module Guard
  class ZeusServer
    class Runner
      attr_accessor :options

      def initialize(options)
        @options = options
      end

      def start
        zeus_options = [
          '-d',
          '-p', port,
          '--pid', pid_file,
        ]

        system "zeus server #{zeus_options.join(' ')}"
      end

      def stop
        if has_pid?
          kill "INT", pid
        end
      end

      def restart
        stop
        start
      end

      private
      def pid
        has_pid? ? File.read(pid_file).to_i : nil
      end

      def pid_file
        File.expand_path("tmp/pids/zeus_#{options.fetch(:command)}.pid")
      end

      def has_pid?
        File.file?(pid_file)
      end

      def port
        options.fetch(:port)
      end
    end
  end
end
