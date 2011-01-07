require "rspec"
require_relative '../processors/record_lookup_processor'
require_relative '../data_sources/data_source_mock'


describe "RecordLookupProcessor" do
  before do
    @ds_mock = DataSourceMock.new
    @proc    = Indexer::RecordLookupProcessor.new(@ds_mock, @ds_mock.document_lookup_field, {:F1=>:f1, :F2=>:f2})
  end


  describe "#process" do

    it "should map data from datasource to document based on keymatch " do

      doc1 = @ds_mock.test_data[1]
      doc2 = @ds_mock.test_data[2]

      result = @proc.process(doc1)

      (result.has_key? :F1).should == true
      (result.has_key? :F2).should == true

      (result[:F1]).should == doc2[:f1]
    end

  end

  describe "#extract" do

  end


end