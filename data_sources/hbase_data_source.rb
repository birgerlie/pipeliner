require_relative 'data_source'
require "massive_record"

module Indexer
  class HbaseDataSource < DataSource
    # To change this template use File | Settings | File Templates.

    include MassiveRecord::Wrapper

    def initialize(options ={})
      super(options)

      @table_name        = options[:table]
      @column_families   =options[:columns] || []
      @table_initialized = initialize_table


      puts "initialized options=> #{options}"
    end

    def initialize_table
      @connection = Connection.new(options[:connection])
      @connection.open

      raise ArgumentError("table #{@table_name} dont exist") unless table_exist?
      info_message("DataSource initialized ")
      true
    end


    def fetch(key)
      initialize_table unless @table_initialized
      tries =0
      done = false
      data = []
      while(!done and tries < 2)
        begin
          data = @connection.tables.load(@table_name).all(:start=>key, :select=>@column_families)
          done = true

        rescue Apache::Hadoop::Hbase::Thrift::IOError => ex
          tries +=1
          info_message(ex)
          sleep(10)
          initialize_table
        end
        
      end

      data.select {|row| row.id.scan(key).count > 0}
    end

    def post_process_rows(data)
      return {} if data == nil
      return {} if data.first == nil

      data.first.values
    end

    def table_exist?
      @connection.tables.select { |table| table == @table_name }
    end

  end
end


#c = {:host=>'thrift.companybook.no' , :port=>9090}
#ds = Indexer::HbaseDataSource.new(:connection=>c,:table=>'myurls')
#ds.read('http://no.expert.www')