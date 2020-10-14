class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
  def self.similar_movies id, options
    opt = options.select { |key,value| value != nil and value != '' }

    if opt.keys.length == 0
      return []
    end

    builder = all()
    opt.each do |key, val|
      builder = builder.where("%s = '%s'" % [key, val])
    end
    builder = builder.where("id != '%s'" % [id])
    builder
  end
  
end
