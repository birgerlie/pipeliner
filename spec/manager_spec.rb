require "rspec"
require_relative '../processors/log_processor'
require_relative '../processors/language_detection_processor'
require_relative '../processors/url_reverse_processor'
require_relative '../processors/record_lookup_processor'

require_relative '../manager'

describe "Manager" do
  before do

    @doc = { 'info:web_address'=>'http://www.test-this.com/', 'content:'=>"<html><title>some title</title><body>and some body</body></html>" ,'url:'=>"http://www.cg.no",'http_code:'=>200,'content_type:'=>'text/html'}
    @processors        =
              [
                  #RecordLookupProcessor.new(finance_data, 'id', {:total_revenue=>'info:total_revenues', :profit_before_tax=> 'info:profit_before_tax'}),
                 Indexer::UrlReverseProcessor.new(:field=>'info:web_address'),
                  Indexer::LogProcessor.new({:include=>[:reverse_url, :profit_before_tax]}),
    #              RecordLookupProcessor.new(url_data, :reverse_url, :html_raw=>'content:', :content_type=>'content_type:'),
    #              CleanHtmlProcessor.new(:html_raw, 'html cleaner'),
                  #NgramProcessor.new({'info:name'=>:n_grams,:html_body=>:n_grams,:html_meta=>:n_grams},2, '|' ),
                  #NgramProcessor.new({'info:name'=>:n_grams,:html_body=>:n_grams,:html_meta=>:n_grams},3, '|' ),
    #              FieldNormalizerProcessor.new,
                  Indexer::LogProcessor.new({:exclude=>[:html_text]})
              ]
    @manager = Indexer::Manager.new([], @processors,[])
  end

  describe 'default inititializer' do
      it "should have equal number of processors and verticies" do
        @manager.dag.graph.vertices == @manager.content_processors
        p "processors:"
        @manager.dag.graph.vertices.each {|v| p v}
      end
  end

  describe "process pipeline" do
    it "Should return a hash" do

        manager =  Indexer::Manager.default 

        retval =  manager.process_pipeline(@doc, nil)
        retval.class.should.eql? Hash

  
    end
  end

  describe "default" do
    it "sould be able to process a doc" do



    end

  end
end