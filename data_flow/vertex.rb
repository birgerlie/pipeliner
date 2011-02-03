
class Vertex
    attr_accessor :value, :name
    def initialize(value)
      @value = value
      @name == self.class.to_s
    end

  def eql? other
    if other.respond_to? :value
      value.eql? other.value
    end
  end

  def to_s
    value == nil ?  '' :  value.to_s
  end
end

class ProcessVertex < Vertex
  def process(data)
    p data
    data
  end
end







