require_relative 'content_processor'
require 'nokogiri'

module Indexer
  class CleanHtmlProcessor < ContentProcessor
    # To change this template use File | Settings | File Templates.

    def initialize(html_key, name = self.class.name)
      super(name)
      @html = html_key
    end

    def process(document)
      raise ArgumentError unless document.is_a? Hash
      values ={}
      values = html2text(document[@html]) if document.has_key? @html
      puts values
      values.each { |k, v| document[k]=v }
      document
    end


    def html2text(html)

      begin
      title =meta= text = ''

      doc   = Nokogiri::HTML::parse(html.force_encoding('utf-8'))
      title = doc.xpath('//title').text.gsub(/\t|\n|\r/, '')

      puts title
      meta  = doc.xpath('//meta/@content').text

      doc.css('script').each { |node| node.remove }
      doc.css('link').each { |node| node.remove }
      text = doc.css('body').text.squeeze(" ").squeeze("\n")
      #tokenize sentences so sentence boundaries are detected better
      text.gsub!("\r", '')
      text.gsub!("\t", '')
      text.gsub!("\n", '')
      rescue Exception =>e
        puts e
        return {:html_title=> '', :html_meta=>'', :html_text=>''}
      end
      {:html_title=>title, :html_meta=>meta, :html_text=>text}
    end

  end
end