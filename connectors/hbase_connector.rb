require_relative 'connector'
require 'massive_record'

module Indexer
  class HbaseConnector < Connector
    include MassiveRecord::Wrapper

    def after_initialize
      @table      = @connection_args[:table]
      @columns    = @connection_args[:columns]
      @connection = inititalize_connection
      if not @table
        raise 'Configuration: :table missing'
      end
    end

    def inititalize_connection
      connection = Connection.new(:host=>@connection_args[:host], :port=> @connection_args[:port])
      connection.open
      connection
    end

    def start
      table = Table.new(@connection, @table)
      info_message("indexing on table #{@table},reading #{@columns}")
      params  = {:select=>@columns,:start=>'NO0000000833354922', :limit=>1 }
      last_id = nil
      tries   = 0
      success = false
#:start=>'NO0000000833354922', :limit=>1   vitek.no har webside brukt for testing av selskap som har mer en en webside
#:start=>'NO0000000947501232', :limit=>1   Skarnes.no har ikke webside brukt for testing av selskap som ikke har en en webside
      while (tries < 3 && !success)
      begin
          table.find_in_batches(params) do |batch|
            puts batch.length
            puts batch.first.id
            batch.each do |row|
              values             = row.values
              values[DOCUMENT_ID]="#{@name}:#{row.id}"
              last_id            = row.id
              info_message("new document #{values[DOCUMENT_ID]}")
              new_document(values)
            end
            success = true
            tries = 0
          end
          rescue Apache::Hadoop::Hbase::Thrift::IOError => ex
          tries +=1
          info_message(ex)
          sleep(10)
          @connection = initialize_table
          params[:start=>last_id]
        end
      end
    end
  end

end