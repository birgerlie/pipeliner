require_relative 'content_processor'

module Indexer
  class RecordLookupProcessor < ContentProcessor

    def initialize(data_source, key_field = :id, key_mapping = {})
      raise 'Not a datasource' if not data_source.is_a? DataSource
      @data_source = data_source
      @key_field   = key_field
      @key_mapping = key_mapping

      puts "intitialized => datasource=>#{@data_source.to_s},key_field=>#{key_field}, mapping -> #{key_mapping}"
    end

    def extract(key)
      @data_source.read(key)
    end

    def process(doc)

      return doc if !doc.has_key? @key_field
      key = doc[@key_field]
      return doc if key == nil

      values = extract(key)

      return doc if values == nil

      @key_mapping.each do |doc_key, value_key|

        if values.has_key? value_key
          doc[doc_key] = values[value_key]
          puts "adding #{doc_key} with #{values[value_key].length} length" 
        end



      end

      doc
    end
  end
end
