require_relative 'content_processor'

module Indexer
class LogProcessor < ContentProcessor
  def initialize(options={})

    options[:include] == nil ? @filters = [] : @filters =  options[:include]
    options[:exclude] == nil ? @exclude_filters = [] : @exclude_filters =  options[:exclude]
  end

  def filter_fields(document)
    if @filters.length == 0
      display = document.keys
    else
      display = @filters
    end
    @exclude_filters.each{ |exclude| display.delete(exclude) }
    display

  end

  def process(document)

    puts ' ############## ############## ##############'
    display = filter_fields document
    display.each {|field_name| emit(field_name, document[field_name])  }
    puts ' ############## ############## ##############'

    document
  end

  def emit(field_name, field_value)
    puts   "Logger:  #{field_name } => #{field_value.to_s}"
  end
end
end