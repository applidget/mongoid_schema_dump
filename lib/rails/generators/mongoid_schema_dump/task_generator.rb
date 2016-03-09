module MongoidSchemaDump
  module Generators
    class TaskGenerator < Rails::Generators::Base
      desc "Creates a Rake task that you can customize for your own schema"

      def self.source_root
        @_source_root ||= File.expand_path("../templates", __FILE__)
      end

      def create_rake_task
        template 'mongoid_schema_dump.rake', File.join('lib', "tasks", "mongoid_schema_dump.rake")
      end

    end
  end
end