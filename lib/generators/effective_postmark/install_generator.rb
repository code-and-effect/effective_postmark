module EffectivePostmark
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      desc 'Creates an EffectivePostmark initializer in your application.'

      source_root File.expand_path('../../templates', __FILE__)

      def self.next_migration_number(dirname)
        unless ActiveRecord::Base.timestamped_migrations
          Time.new.utc.strftime("%Y%m%d%H%M%S")
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end

      def copy_initializer
        template ('../' * 3) + 'config/effective_postmark.rb', 'config/initializers/effective_postmark.rb'
      end

      def create_migration_file
        migration_template ('../' * 3) + 'db/migrate/101_create_effective_postmark.rb', 'db/migrate/create_effective_postmark.rb'
      end
    end
  end
end
