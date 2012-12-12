require 'fileutils'

module Guard
  class ZeusServer
    class Runner
      attr_accessor :options

      def initialize(options)
        @options = options
      end

      def start
        delete_abandonded_pid_file
        return if has_pid?

        zeus_options = [
          '-d',
          '-p', port,
          '-P', pid_file,
        ]

        system "cd #{Dir.pwd}; zeus server #{zeus_options.join(' ')}"
      end

      def stop
        if has_pid?
          system %{kill -SIGINT #{pid}}
        end
      end

      def restart
        stop
        start
      end

      private
      def delete_abandonded_pid_file
        return unless has_pid?
        return if system("kill -0 #{pid}")

        FileUtils.rm pid_file
      end

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
