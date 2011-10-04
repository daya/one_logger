require "one_logger/version"

module OneLogger
  module Glue
    def self.included base #:nodoc:
      base.extend ClassMethods
    end
  end
  
  module ClassMethods
    def exclusively_log_to your_logger
      Thread.current[:logger] = your_logger
      include OneLogger::Throughout
    end  
  end
  
  module Throughout
    def self.included base
      y "#{self} included by #{base}"
      # base.extend System
      base.send(:eval, 
        %Q{
          def self.original_logger
            @@logger
          end
          def self.logger
            Thread.current[:logger] || @@logger || RAILS_DEFAULT_LOGGER
          end
        })
    end
  end

  module ConnectionAdapterLogger
    def self.included base
      base.class_eval do
        attr_reader :logger

        def logger
          @logger = (Thread.current[:logger] || @logger)
        end
      end
    end
  end  
  
  def self.included base
    base.extend ClassMethods
  end
end
