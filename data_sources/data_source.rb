require_relative '../event_handler'
require_relative '../event_handler'
#abstract base class for reading some data based on a key
module Indexer
  class DataSource
    include EventHandler
    attr_accessor :options, :name, :description
    @@count = 0
    def initialize(options ={}, name=self.class.name, description='')
      super()
      @@count |=1
      @options = options
      @name = name
      @name +=  " #{@@count}" if name == self.class.name
      @description = description
    end

    #read a record and return the data to the associated key
    def read(key)
      info_message("reading #{key}")
      post_process_rows(fetch(pre_process_key(key)))
    end

    def fetch(key)

    end

    def pre_process_key(key)
      key
    end
    def post_process_rows(data)
      data != nil ? data.first : {}
    end


  end
end

