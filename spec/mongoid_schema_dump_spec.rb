require 'spec_helper'
require "mongoid"

class Organization
  include Mongoid::Document
  include Mongoid::Timestamps 
  
  has_many :repositories 
  
  field :name
end

class Repository
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :organization
  has_many :commits
  field :name
end

class Commit
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :repository
  field :commit_id
end

describe MongoidSchemaDump do
  
  it 'returns all Mongoid models' do
    expect(MongoidSchemaDump.models.sort).to eq(["Organization", "Repository", "Commit"].sort)
  end
  
  it "returns all dependencies" do
    schema = MongoidSchemaDump.dump("Organization")
    mapping = schema.reduce({}) do |memo, current|
      memo[current["collection"]] = current
      memo
    end
    expect(mapping["organizations"]).to be(nil)
    expect(mapping["repositories"]["dependency"]).to eq("organizations")
    expect(mapping["commits"]["dependency"]).to eq("repositories")
  end

end
