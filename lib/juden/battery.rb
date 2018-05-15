require_relative 'config'

module Juden
  class Battery
    
    attr_reader :percentage, :state

    def initialize
      @percentage = `upower -i $(upower -e | grep BAT) | grep percentage`.split.last
      @state      = `upower -i $(upower -e | grep BAT) | grep state`.split.last
    end

    # @return [Boolean]
    def low_battery?
      percentage.to_i < config.threshold_percentage
    end

    # @return [Integer]
    def percentage_num
      percentage.split('%').first.to_i
    end

    # @return [Boolean]
    def discharging?
      state == 'discharging'
    end

    private

    # @return [Config]
    def config
      Config.instance
    end
  end
end
