require_relative 'content_processor'
require_relative 'record_lookup_processor'

module Indexer
  class ForEachProcessor < RecordLookupProcessor

    def process(document)
      doc = [document]
      return doc if !document.has_key? @key_field
      key = document[@key_field]
      return doc if key == nil

      docs   = []

      return doc if key.length < 5
      values = extract(key)
      return [document] if values == nil

      puts values.class
      puts "values length:" + values.length.to_s


      values.each do |item|
        new_doc = document.clone



        key_mapping.each do |doc_key, value_key|
          if item.values.has_key? value_key
            new_doc[doc_key] = item.values[value_key]
            puts "adding #{doc_key} with #{item.values[value_key].length} length"
          end
        end
        docs << new_doc
      end
      docs
    end
  end
end
