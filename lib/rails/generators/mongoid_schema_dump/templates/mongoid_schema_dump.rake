require "mongoid_schema_dump"
namespace :mongoid do
  task :schema_dump => :environment do
    #This is used to make sure all your models are loaded 
    Rails.application.eager_load!
    
    #Customize your base class here )
    MongoidSchemaDump.dump("Organization")
  end
end
