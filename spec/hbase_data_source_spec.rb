require "rspec"
require 'massive_record'
require_relative '../data_sources/hbase_data_source'
describe "HbaseDataSource" do

  before do
    @connection_args = {:host=>'thrift.companybook.no',:port=>9090}
    @table ='companies_development'
    @columns = []
    @connection = MassiveRecord::Wrapper::Connection.new(@connection_args)
    @connection.open
    @expected = @connection.load_table(@table).first(:select=>@columns).values
    @ds = Indexer::HbaseDataSource.new({:connection=> @connection_args,:table=>@table, :columns=>@columns} )
  end

  describe "#read" do
      it "should return the same data set as read from Hbase expected" do
        puts @expected["id"]
        read_result = @ds.read(@expected['id'])
        read_result.should == @expected
      end
  end


end