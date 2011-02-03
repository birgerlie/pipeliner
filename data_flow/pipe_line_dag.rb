require_relative 'vertex_edge_list'
require_relative 'vertex'
require_relative 'edge'
require_relative 'breadth_first_search'

class PipeLineDag < BreadthFirstSearch


  def initialize (graph, start)
    super(graph)
    @start = start
  end

  def process(document)
    @data = document
    #p "processing doc " + document.to_s
    run(@start)
    #p "done with doc " + document.to_s
    @data
  end

  def current_vertex(vertex)
    if(vertex.respond_to? :process)
     # p vertex.to_s
      if(@data.is_a? Array)
        @data = @data.map{|item| vertex.process item.clone}
      else
        @data = vertex.process(@data.clone)
      end
    end
  end

  def current_edge(edge)
    #p edge.to_s
  end
end