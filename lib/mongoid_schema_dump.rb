require "mongoid_schema_dump/version"

module MongoidSchemaDump
  require 'mongoid_schema_dump/engine' if defined?(Rails)
  module_function
  
  #Computes all paths to reference class
  def paths_to_klass(klass, reference_klass)
    displayed_for_klass = false
    paths = []
    to_visit = [[klass, []]]
    current_klass = klass
    
    loop do
      current_klass, path = to_visit.pop #FIFO
      break unless current_klass  
      path << current_klass
    
      if current_klass.to_s == reference_klass 
        paths << path
        next
      end
      break if current_klass.nil?
      next_klasses = all_belongs_to(current_klass)
      next_klasses.each do |next_klass|
        next if next_klass == current_klass.to_s
        to_visit << [next_klass.constantize, path.clone]
      end
      break if to_visit.empty?
    end
    return paths 
  end
  
  #returns all has_many relation class names
  def has_many(from_klass, to_klass)
    all_has_many = from_klass.relations.map(&:second).select do |r| 
      r.macro == :has_many && r.class_name == to_klass.to_s
    end.map(&:class_name)
  end
  
  #returns all belongs_to class names 
  def all_belongs_to(from_klass)
    monomorphic_relations = from_klass.relations.map(&:second).select do |r| 
      r.macro == :belongs_to && !r[:polymorphic]
    end.map do |relation|
      relation.class_name
    end
    
    polymorphic_relations = from_klass.relations.map(&:second).reduce([]) do |memo, r| 
      if r.macro == :belongs_to && r[:polymorphic] == true
        models.each do |model_klass_name|
          next unless has_many(model_klass_name.constantize, from_klass).any?
          next if monomorphic_relations.include? model_klass_name
          memo << model_klass_name 
        end
      end
      memo
    end
    monomorphic_relations + polymorphic_relations
  end
  
  def models
    Mongoid.models.map &:to_s
  end
  
  def shortest_array(arrays)
    result = arrays.reduce({path: [], size: 1000000}) do |memo, current|
      new_size = [current.count, memo[:size]].min
      memo = {path: current, size: new_size} if new_size < memo[:size]
      memo
    end
    result[:path]
  end
  
  def export_options(klass_name, ref)
    path = shortest_array(paths_to_klass(klass_name.constantize, ref))
    return {} if path.count <= 1
    dependency_klass = path.second
    
    #1. Standard belongs_to
    relation = klass_name.constantize.relations.map(&:second).select do |r| 
      r.macro == :belongs_to && !r[:polymorphic] && r.class_name == dependency_klass.to_s
    end.first
    if relation.present?
      return {
        "collection" => klass_name.constantize.collection.name,
        "dependency" => dependency_klass.collection.name,
        "foreign_key" => relation.key
      }
    end
    
    #2. Handle polymorphic relations 
    hm_names = dependency_klass.relations.map(&:second).select do |r| 
      r.macro == :has_many && r.class_name == klass_name
    end.map(&:as)
    
    relation = klass_name.constantize.relations.map(&:second).select do |r| 
      r.macro == :belongs_to && r[:polymorphic] == true && hm_names.include?(r.name)
    end.first
    return nil if relation.blank?
    
    return {
      "collection" => klass_name.constantize.collection.name,
      "dependency" => dependency_klass.collection.name,
      "foreign_key" => relation.key,
      "filters" => {
        "#{relation.name}_type" => dependency_klass.to_s
      }
    }
  end
  
  def dump(reference_klass_name)
    #path_to_reference_klass(model_name.constantize, "Guest")  
    schema = []
    models.each do |model_name|    
      res = export_options(model_name, reference_klass_name)
      schema << res if res.present?
    end
    return schema
  end
end
