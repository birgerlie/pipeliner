require_relative 'vertex'
require_relative 'edge'

class VertexEdgeList
attr_accessor :graph

def initialize
    @edges =[]
    @graph = {}
  end

  def vertices
    @graph.keys
  end

  def edges
    @edges
  end

def [](key)
    @graph[key]
  end

  def []= (key,value)
    @graph[key] ||= []
    @graph[key] << value
  end

  def add_vertex(vertex)
    @graph[vertex] = [];
  end

  def add_edge(edge)

    raise "edge cannot be nil: " if edge == nil
    raise "source does not exist: "  + edge.to_s unless @graph.has_key? edge.source
    raise 'target does not exist:' + edge.to_s unless @graph.has_key? edge.target
    @graph[edge.source].insert(0,edge)
    @edges << edge
  end
  def remove_edge(edge)
    @graph[edge.source].delete edge
    @edges.delete edge
  end

  def out_edges(vertex)
    raise 'edges dont exist' unless has_vertex? vertex
    @graph[vertex].clone
  end

  def has_vertex?(vertex)
    @graph.has_key? vertex
  end



  def out_count(vertex)
    @graph[vertex].length
  end

  def self.create_graph_from_array(vertex_array = [])
    graph = VertexEdgeList.new
    vertex_array.each{|v| graph.add_vertex v}

    prev = vertex_array.first

    i=1
   while i < vertex_array.size do

      curr = vertex_array[i]
      graph.add_edge(Edge.new(prev, curr))
      prev = curr
     i+=1
    end
    graph
  end
end