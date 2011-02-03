require "rspec"
require_relative '../data_flow/pipe_line_dag'
require_relative '../data_flow/vertex_edge_list'
require_relative '../data_flow/vertex'
require_relative '../data_flow/edge'
require_relative '../processors/log_processor'

describe "process" do
  before do

    @graph        = VertexEdgeList.new
    logger1       = Indexer::LogProcessor.new
    logger1.value = "logger 1"


    logger2       = Indexer::LogProcessor.new
    logger2.value = 'logger 2'
    logger3       = Indexer::LogProcessor.new
    logger3.value = 'logger 3'

    @loggers      = [logger1, logger2, logger3,]

    @loggers.each { |vertex| @graph.add_vertex vertex }
    @graph.add_edge(Edge.new(logger1, logger2))
    @graph.add_edge(Edge.new(logger2, logger3))
    @pipe_line = PipeLineDag.new(@graph, logger1)

    @doc       = {'content:'=>"<html><title>some title</title><body>and some body</body></html>", 'url:'=>"http://www.cg.no", 'http_code:'=>200, 'content_type:'=>'text/html'}
  end

  it "should process a document" do

    result = @pipe_line.process @doc

    result.should_not.eql? nil
    result.should.eql? @doc
  end

  it "should process several documents in order" do

    [{:first=>1}, {:second=>2}, {:third=>3}, {:fourth=>4}, {:fifth=>5}].each do |doc|

      res = @pipe_line.process doc
      @pipe_line.visited_vertices.should == @loggers
      p res
      res.should == doc

    end
  end
  it "should execute processes in the correct order" do
    count = 0
    @pipe_line.listen_event(:current_vertex) do |v|
      v.should.eql? @loggers[count]
      p 'logger: ' + v.to_s
      count +=1
    end

    @pipe_line.process @doc
  end

end