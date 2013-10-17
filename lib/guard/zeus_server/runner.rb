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
        return true if has_pid?

        zeus_options = [
          '-d',
          '-p', port,
          '-P', pid_file,
        ]
        command = "cd #{Dir.pwd}; zeus server #{zeus_options.join(' ')}"
        if run_without_bundler
          require 'bundler'
          Bundler.clean_system command
        else
          system command
        end
        wait_until { has_pid? }
      end

      def stop
        kill if has_pid?
        true
      end

      def restart
        stop
        start
      end

      private
      def kill
        pid = read_pid
        system "kill -SIGINT #{pid}"

        unless wait_until { !has_pid? }
          system "kill -SIGKILL #{pid}"
          delete_pid_file
        end
      end

      def running?(pid)
        system "kill 0 #{pid}"
      end

      def wait_until(&block)
        thread = Thread.new do
          until block.call
            sleep 0.1
          end
        end
        !!thread.join(10)
      end

      def delete_abandonded_pid_file
        return unless has_pid?
        return if system("kill -0 #{read_pid}")

        delete_pid_file
      end

      def delete_pid_file
        FileUtils.rm pid_file
      end

      def read_pid
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

      def run_without_bundler
        options.fetch(:run_without_bundler)
      end
    end
  end
end
