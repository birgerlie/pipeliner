require_relative 'connectors/hbase_connector'
require_relative 'search_engines/solr_search'
require_relative 'processors/clean_html_processor'
require_relative 'processors/field_normalizer_processor'
require_relative 'processors/log_processor'
require_relative 'processors/language_detection_processor'
require_relative 'processors/url_reverse_processor'
require_relative 'processors/record_lookup_processor'
require_relative 'processors/for_each_processor'
require_relative 'observers/information_observer'
require_relative 'observers/index_counter_observer'
require_relative 'data_sources/hbase_data_source'
require_relative 'data_sources/hbase_each_data_source'
require_relative 'processors/ngram_processor'
require_relative 'data_flow/pipe_line_dag'
require_relative 'data_flow/vertex_edge_list'

module Indexer

  class Manager
    attr_accessor :last_indexed, :run, :dag, :content_processors 

    def initialize(connectors=[], processors =[], search_engines=[], last_modified = DateTime.new(2000))
      @search_engines     = []
      @connectors         ={}
      @index_threads      ={}
      @content_processors = processors
      @timestamp          = last_modified

      connectors.each { |connector| add_connector(connector) }
      search_engines.each { |search_engine| add_search_engine(search_engine) }

      graph = VertexEdgeList.create_graph_from_array processors

      @dag = PipeLineDag.new(graph, processors.first)
    end

    def add_connector(connector)

      raise "Connector name unique #{connector.name}" if @connectors.has_key? connector.name

      connector.attach_connector_starting do |a|
        puts "indexing starting #{a}"
      end
      connector.attach_new_document_listener(method(:process_pipeline))
      connector.attach_connector_complete do |a|
        puts "indexing complete #{a}"
      end

      #Indexer::InformationObserver.new(connector)
      @connectors[connector.name] = connector
    end

    def add_search_engine(search_engine)
#    search_engine.attach_info_listener do |message,sender
#      puts "message: #{message}  from:#{sender}"
#    end
      #InformationObserver.new(search_engine)
      @search_engines << search_engine
    end

    def index_data
      counters =[]
      @connectors.each_value { |connector| counters << IndexCounterObserver.new(connector); connector.index_content }
      #counters.each { |counter| puts counter.count }
    end

    def process_pipeline(document, sender)

      #puts 'pipeline recieved: ' + document.to_s + " from "  + sender.to_s
      documents = @dag.process document

      documents.each do |doc|
      @search_engines.each {|engine| engine.publish(doc)}
      end
    end


    def stop
      @connectors.each { |name, connector| connector.stop; puts "stopping #{name}" }
    end

    def state
      @connectors.map { |name, connector| {name => connector.state} }.flatten()
    end

    def self.default(deployment_type = 'development')

      connection_params ={:host=>'thrift.companybook.no', :port=>9090}
      url_data          = HbaseEachDataSource.new(:connection=>connection_params, :table=>'urls', :columns=>['content:', 'meta:url', 'meta:http_code:', 'meta:content_type:'])
      finance_data      = HbaseDataSource.new(:connection=>connection_params, :table=> "finances_" + deployment_type, :columns=>['info'])
      connectors        = [HbaseConnector.new({:host=>'thrift.companybook.no', :port=>9090, :table=>"companies_" + deployment_type, :columns=>['info:web_address']}, [])]
      processors        =
          [
              RecordLookupProcessor.new(finance_data, 'id', {:total_revenue=>'info:total_revenues', :profit_before_tax=> 'info:profit_before_tax'}),
              UrlReverseProcessor.new(:field=>'info:web_address'),
              #LogProcessor.new({:include=>[:reverse_url, :profit_before_tax]}),
              ForEachProcessor.new(url_data, :reverse_url, :html_raw=>'content:', :content_type=>'content_type:', :page_url=>'meta:url'),
              CleanHtmlProcessor.new(:html_raw, 'html cleaner'),
              #NgramProcessor.new({'info:name'=>:n_grams,:html_body=>:n_grams,:html_meta=>:n_grams},2, '|' ),
              #NgramProcessor.new({'info:name'=>:n_grams,:html_body=>:n_grams,:html_meta=>:n_grams},3, '|' ),
              FieldNormalizerProcessor.new,
              LogProcessor.new({:exclude=>[:html_text]})
          ]

      search_engines    =
          [
          SolrSearch.new({:connection_args=>{:server=>'http://46.51.180.198:8983/solr/company_' + deployment_type  }, :name=>'company_' + deployment_type}),
          #SolrSearch.new({:connection_args=>{:server=>'http://46.51.180.198:8983/solr/company_test'}, :name=>'company_test'} )
          ]
      Manager.new(connectors, processors, search_engines)
    end
  end


#  #profit_before_tax
#
#
  indexer = Manager.default ARGV[0]
  indexer.index_data

end