require 'one_logger'

module OneLogger
  if defined? Rails::Railtie
    require 'rails'
    class Railtie < Rails::Railtie
      initializer 'paperclip.insert_into_active_record' do
        ActiveSupport.on_load :active_record do
          OneLogger::Railtie.insert
        end
      end
      rake_tasks do
        load "tasks/paperclip.rake"
      end
    end
  end

  class Railtie
    def self.insert
      ActiveRecord::Base.send(:include, OneLogger::Glue)
      ActiveRecord::ConnectionAdapters::AbstractAdapter.send(:include, OneLogger::ConnectionAdapterLogger)
    end
  end
end
