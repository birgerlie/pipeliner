require_relative 'data_source'


class DataSourceMock < Indexer::DataSource
  # To change this template use File | Settings | File Templates.

  def initialize(options ={})
    super(options)
    if options.has_key? :input
      @values = options[:input]
    else
      @values =
      {
          1=>{:id=>1, :id_o=>2, :f1=>:AA, :f2=>:AAA},
          2=>{:id=>2, :id_o=>3, :f1=>:BB, :f2=>:BBB},
          3=>{:id=>3, :id_o=>1, :f1=>:CC, :f2=>:CCC}
      }
    end
  end

  def test_data
      @values  
  end

  def document_id
    :id
  end

  def document_lookup_field
    :id_o
  end

  def read(key)
    raise ArgumentError unless @values.has_key? key
    @values[key]
  end

end
