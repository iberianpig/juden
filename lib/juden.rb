require_relative 'juden/version'
require_relative 'juden/config'
require_relative 'juden/battery'
require 'open3'
require 'date'
require 'yaml'

module Juden
  class Notifier
    class << self
      def run
        new.run
      end
    end

    def run
      loop do
        if send_reminder?
          post_to_webhook
        else
          puts %(Don't have to send remainder)
        end
        sleep config.interval_seconds
      end
    end

    private

    # @return [Config]
    def config
      Config.instance
    end

    # @return [Battery]
    def battery
      @battery ||= Battery.new
    end

    # @return [Boolean]
    def send_reminder?
      battery.discharging? && battery.low_battery? && create_lock
    end

    def create_lock
      system("mkdir /tmp/juden_lock_#{Date.today.iso8601}")
    end

    def delete_lock
      system("rm -d /tmp/juden_lock_#{Date.today.iso8601}")
    end

    def post_to_webhook
      # puts curl_command.to_s
      if system(curl_command)
        puts "\nsuccess"
      else
        puts "\nfailed"
        delete_lock
      end
    end

    def curl_command
      %(curl -i -X POST \
        -H "Content-Type:application/json" \
        -d \
        '{ "value1" : "#{config.device_name}", "value2" : "#{battery.state}, #{battery.percentage}", "value3" : "" }' \
      #{config.webhook_url})
    end
  end
end
