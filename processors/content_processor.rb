require_relative "../event_handler"
require_relative "../data_flow/vertex"

module Indexer
  class ContentProcessor < Vertex
    attr_accessor :name
    include EventHandler

    def initialize(name=self.class.name)
      @name = name
    end
    
    def exec(document)
      assert_document(document)
      process (document)
    end

    def assert_document(document)
      raise "Document is a #{document.class.name} expected Hash in #{self.class.name}" unless document.is_a? Hash
    end

    def process(document)
        
    end

  end
end