require "rspec"
require_relative '../data_sources/data_source'
describe "DataSource" do
  before do
    @ds = Indexer::DataSource.new({})
  end

  it "should should return a Array" do

    #To change this template use File | Settings | File Templates.
    (@ds.read('key').is_a? Hash).should == true

  end
end