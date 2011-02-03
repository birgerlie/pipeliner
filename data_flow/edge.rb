class Edge

  attr_accessor :source, :target

  def initialize(vertex_source, vertex_target)
    @source = vertex_source
    @target = vertex_target
  end

  def to_s
    "#{@source.to_s} => #{@target.to_s}"
  end
end