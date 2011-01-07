require_relative 'connector'
require 'massive_record'

module Indexer
  class HbaseConnector < Connector
    include MassiveRecord::Wrapper
    def after_initialize
      @table   = @connection_args[:table]
      @columns = @connection_args[:columns]

      if not @table
        raise 'Configuration: :table missing'
      end
    end

    def start
      connection = Connection.new(:host=>@connection_args[:host], :port=> @connection_args[:port])
      connection.open
      table = Table.new(connection, @table)

      info_message("indexing on table #{@table},reading #{@columns}")

      table.find_in_batches(:select=>@columns) do |batch|
        puts batch.length
        puts batch.first.id
        batch.each do |row|
          values = row.values
          values[DOCUMENT_ID]="#{@name}:#{row.id}"
          info_message("new document #{values[DOCUMENT_ID]}")
          new_document(values)
        end
      end
    end
  end

end