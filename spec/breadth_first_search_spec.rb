require "rspec"
require_relative '../data_flow/breadth_first_search'
require_relative '../data_flow/vertex'
require_relative '../data_flow/vertex_edge_list'

describe 'run' do
  before do
    @list     = VertexEdgeList.new
    @vertices = [Vertex.new(1), Vertex.new(2), Vertex.new(3), Vertex.new(4)]
    @vertices.each { |v| @list.add_vertex v }
    @list.add_edge(Edge.new(@vertices[0], @vertices[1]))
    @list.add_edge(Edge.new(@vertices[1], @vertices[2]))
    @list.add_edge(Edge.new(@vertices[2], @vertices[3]))


  end

  it "should iterate all verices as array" do


    visited = []
    bfs     = BreadthFirstSearch.new(@list)
    bfs.listen_event(:current_vertex) do |v|
      visited << v
    end
    5.times do

      visited = []

      bfs.run()

      bfs.visited_vertices.should == @vertices
      visited.should == @vertices
    end
  end

  it "should iterate all verices several times with same result" do

    @list.add_edge(Edge.new(@vertices[3], @vertices[2]))
    visited = []
    bfs     = BreadthFirstSearch.new(@list)
    bfs.listen_event(:current_vertex) do |v|
      visited << v
    end
    5.times do

      visited = []
      bfs.run()

      bfs.visited_vertices.should == [@vertices, @vertices[3]].flatten
      visited.should == [@vertices, @vertices[3]].flatten
    end
  end

  describe "run with multipe shildren" do
    before do
      @list     = VertexEdgeList.new
      @vertices = []
      count = 15
      count.times {|i| @vertices << Vertex.new(i)}
      @vertices.each { |v| @list.add_vertex v }

      p @vertices

      (count/2).times do |i|
#                 1
#               2   3
#             4  5  6  7
        @list.add_edge Edge.new(@vertices[i],@vertices[ (2*i) + 1])
        @list.add_edge Edge.new(@vertices[i],@vertices[ (2*i) + 2])
      end
    end

    it "should processs nodes in correct order" do
      bfs = BreadthFirstSearch.new(@list)
      
      visited = []
      bfs.listen_event :current_vertex do |vertex|
        visited << vertex
      end

      bfs.run

      visited.should == @vertices


    end

  end


end