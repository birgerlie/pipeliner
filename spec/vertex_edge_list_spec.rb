require "rspec"
require_relative '../data_flow/edge'
require_relative '../data_flow/vertex'
require_relative '../data_flow/vertex_edge_list'

describe "vertex_edge_list" do

  describe "add_vertex" do
    before do
      @list   = VertexEdgeList.new
      @vertex = Vertex.new "hey"
      @list.vertices.length.should.eql? 0
      @list.add_vertex @vertex
    end
    it "should add one vertex" do
      @list.vertices.length.should.eql? 1
    end
    it "should have the right vertex first" do
      @list.vertices.first.should == @vertex
    end
  end



  describe "add add edge" do
    before do
      @list = VertexEdgeList.new
       @oslo = Vertex.new "oslo"
      @bergen = Vertex.new "bergen"
       @list.add_vertex @oslo
      @list.add_vertex @bergen

    end

    it "should raise exception when vertex is not part of graph" do

      wrong = Vertex.new('jalla')
      @list.edges.length.should.eql? 0

      lambda { @list.add_edge(Edge.new(@oslo, wrong)) }.should raise_error
    end


    it "should add one edge" do
      @list.edges.length.should.eql? 0
      @list.add_edge(Edge.new @oslo, @bergen)
      @list.edges.length.should.eql? 1

      @list.edges.first.source.should.eql? @oslo
      @list.edges.first.target.should.eql? @bergen
    end

    it "adding an edge sould be assigned to the right vertex" do
      @list.add_edge(Edge.new @oslo, @bergen)
      @list.edges.first.target.should.eql? @bergen

      @list[@oslo].first.source.should.eql? @bergen
      @list[@bergen].length.should.eql? 0
    end
  end

  describe "remove edge" do
    it "should remove an edge" do
      list   = VertexEdgeList.new
      oslo   = Vertex.new "oslo"
      bergen = Vertex.new "bergen"
      list.add_vertex oslo
      list.add_vertex bergen

      list.add_edge(Edge.new oslo, bergen)
      list.add_edge(Edge.new bergen, oslo)
      list.remove_edge(Edge.new(oslo, bergen))
      list.edges.length.should.eql? 1
      list[oslo].length.should.eql? 0
    end
  end

  describe "out_edges" do
    it "should return edges" do
      list   = VertexEdgeList.new
      oslo   = Vertex.new "oslo"
      bergen = Vertex.new "bergen"
      trondheim = Vertex.new "trondheim"
      stavanger = Vertex.new "stavanger"

      list.add_vertex oslo
      list.add_vertex bergen

      list.add_edge(Edge.new oslo, bergen)
      list.add_edge(Edge.new bergen, oslo)

      list.out_edges(oslo).first.class.should == Edge
      list.out_edges(oslo).first.target == bergen

      list.out_edges(oslo).class.should == Array
    end
  end

  describe "create_graph_from_array" do
    before do
      @vertices = [Vertex.new(1), Vertex.new(2), Vertex.new(3),Vertex.new(4) ]
      @graph = VertexEdgeList.create_graph_from_array @vertices
    end

    it "should build a VertexAndEdgeList" do
      @graph.class.should == VertexEdgeList
    end

    it "should have equal number of  vertices" do
      @graph.vertices.length.should == @vertices.length
    end

    it "should create vertices in the right order" do
      @graph.vertices.first.value.should == @vertices.first.value
      @graph.vertices.length.should == @vertices.length
      @graph.vertices.last.value.should == @vertices.last.value
    end

    it "should have the right edge count" do
      len = @vertices.length
      len -=1
      @graph.edges.count.should == len
    end

    it "iterate nodes in correct order" do
       
    end

  end

end




