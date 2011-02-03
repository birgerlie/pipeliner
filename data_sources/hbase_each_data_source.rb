require_relative 'data_source'
require "massive_record"

module Indexer


  class HbaseEachDataSource < HbaseDataSource

     def post_process_rows(data)
       data == nil ? [] : data
     end

    
  end
end
