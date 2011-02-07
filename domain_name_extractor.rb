require_relative 'connectors/hbase_connector'

class DomainNameExtractor

  def initialize
    @connection_params ={:host=>'thrift.companybook.no', :port=>9090}
    @connector         = Indexer::HbaseConnector.new({:host=>'thrift.companybook.no', :port=>9090, :table=>"companies_development", :columns=>['info:web_address']}, [])
    @connector.attach_new_document_listener(method(:print_data))
    @values = {}
    @connector.index_content

  end

  def print_data(row, sender)

    puts row.class

    if (row != nil)
      id     = row['id']
      domain = id = row['info:web_address']
      puts id
      puts domain
      if (domain != nil and domain.length > 0 and id != nil)
        @values[domain]=id
      end

    end

  end
end


DomainNameExtractor.new