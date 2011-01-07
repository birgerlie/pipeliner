require_relative 'content_processor'
require_relative '../classifiers/n_gram_generator'
module Indexer


  class NgramProcessor < ContentProcessor
    # To change this template use File | Settings | File Templates.
    attr_accessor :fields, :delimiter, :gram_type


    def initialize(ngram_fields = {}, gram_type = 2, delimiter = '|')
      super()


      ngram_fields = [ngram_fields] if ngram_fields.is_a? String
      if ngram_fields.is_a? Array
        tmp = {}
        ngram_fields.each { |field| tmp[field] = field + "_#{gram_type}" }
        ngram_fields = tmp
      end

      raise ArgumentError unless ngram_fields.is_a? Hash
      raise ArgumentError unless gram_type.is_a? Fixnum
      raise ArgumentError unless delimiter.is_a? String

      @fields          = ngram_fields
      @delimiter       = delimiter
      @gram_type       = gram_type
      @ngram_tokenizer =   NGramGenerator.new

    end

    def process(document = {})
      grams =[]
      @fields.each do |input, output|
        next unless document.has_key? input
        grams = @ngram_tokenizer.gramify(document[input], @gram_type) if document[input].is_a? String
        document.has_key?(output) ? document[output]+=grams : document[output] = grams
      end

      @fields.each do |input, output|
        document[output].join(delimiter)
      end

      document
    end
  end
end