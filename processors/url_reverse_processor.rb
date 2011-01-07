require 'uri'
require_relative 'content_processor'

module Indexer
  class UrlReverseProcessor < ContentProcessor
    def initialize(options={})
      super(options)
      @url_field = options[:field]
    end

    def process(document)

      unless document.has_key? @url_field
        #TODO Add logging
        return document
      end



      url = document[@url_field]

      if url == nil
        #todo Add logging
        return document
      end

      url =reverse_url(url)
      document[:reverse_url] = url
      document
    end

    def reverse_host(url_string)

      raise ArgumentError unless url_string.is_a? String

      url = URI.parse(url_string)
      unless url.is_a? URI::HTTP
        url_string = 'http://'+ url_string
        url        = URI.parse(url_string)
      end
      url.host.split('.').reverse.join('.')
    end

    def reverse_url(url_string)
      raise ArgumentError unless url_string.is_a? String
      
      begin
      url = URI.parse(url_string)
      if not url.is_a? URI::HTTP
        url_string = 'http://'+ url_string
        url        = URI.parse(url_string)
      end
      url.host = reverse_host(url.host)

      url.to_s
      rescue Exception =>ex
      puts ex.message
        return ''
      end

    end
  end
end