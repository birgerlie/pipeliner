require_relative 'edge'
require_relative 'vertex'
require_relative 'vertex_edge_list'
require_relative '../event_handler'
class BreadthFirstSearch
  include Indexer::EventHandler
  attr_reader :graph, :visited_vertices

  def initialize(graph)
    super()
    @graph = graph
  end

  def current_vertex(node)
    p "current vertex:" + node.to_s
  end

  def current_edge(edge)
    p "current edge: " + edge.to_s
  end


  def run(start = @graph.vertices.first)

    @visited_vertices = nil
    raise ArgumentError unless start.is_a? Vertex
    current_vertex= start
    current_vertex(current_vertex)
    trigger_event(:current_vertex, current_vertex)
    @visited_vertices = [start]
    todo = @graph.out_edges(start)

    yield start if block_given?

    while todo.length > 0 do

      current_edge = todo.pop

      current_edge(current_edge)
      trigger_event(:current_edge, current_edge)

      current_vertex = current_edge.target
      current_vertex(current_vertex)
      trigger_event(:current_vertex, current_vertex)

      @graph.out_edges(current_vertex).each { |edge| todo.push edge;}
      @visited_vertices << current_vertex

      yield(current_vertex) if block_given?
    end

    @visited_vertices
  end
end


