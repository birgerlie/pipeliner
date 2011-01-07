require_relative 'content_processor'


module Indexer
  class LanguageDetectionProcessor < ContentProcessor
    def initialize (options ={})
      @language_field = options[:detect]
      raise ArgumentError "missing :detect key in options" if @language_field == nil
      
    end

    def detect_language(text)
      @detector.detect(text)
    end

    def process(document)
      text = document[@language_field]
      language = detect_language(text)
      document[:LANGUAGE] = language

      document
    end

  end
end