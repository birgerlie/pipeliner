require_relative 'search_engine'
require 'solr'

module Indexer
  class SolrSearch < SearchEngine

    def initialize(options ={})
      super(options)
    end

    def after_initialize
      @search_server = Solr::Connection.new(@connection_args[:server], :autocommit => :on)

      
      info_message("opening connection to #{@connection_args[:server]}")
      @counter = 0
    end

    def write_document_to_index(document)
      #puts document

      begin
      info_message("wrote doc to index #{document[DOCUMENT_ID]}" )

      @search_server.add(document)
      @counter +=1

      if (@counter % 50) ==0
        @search_server.commit()
        info_message("commiting on index")
      end
      end
    rescue Exception =>ex
      puts ex
      info_message(ex.message)
      #todo logging
    end


    def transform_document_before_write(document)
      document.each do |k,v|
        if v.is_a? String
          document[k]=v.force_encoding('utf-8')
        end
      end

      document
    end
  end
end