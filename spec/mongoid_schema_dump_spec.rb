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
  has_many :comments, as: :commentable
  field :commit_id
end

class Comment 
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :commentable, polymorphic: true
end

describe MongoidSchemaDump do
  
  it 'returns all Mongoid models' do
    expect(MongoidSchemaDump.models.sort).to eq(["Organization", "Repository", "Commit", "Comment"].sort)
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
    expect(mapping["comments"]["dependency"]).to eq("commits")
  end

end
