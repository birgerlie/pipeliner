require 'nokogiri'
require 'date'

class MoreoverXmlFileReader
  attr_accessor :path
  def initialize(path='')
    @path = path
  end


  def get_documents(start_id=0, filter={})
    puts @path
    Enumerator.new do |yielder|
      #find_files_from_id(Dir[@path].sort, start_id).each do |file|
       Dir[@path].each do |file|
        puts file
        get_articles_from_xml_file(file).
          map {|article| process_article(article) }.
          select {|article| filter_article(article, filter) }.
          each {|article| yielder.yield article if article[:article_id].to_i >= start_id.to_i  }
      end
    end
  end


  def find_files_from_id(files, start_id)
    next_file = files.find {|f| /\d+/.match(f)[0].to_i >= start_id.to_i }
    return [] if not next_file
    index = files.index(next_file)
    index > 0 ? files[index-1..-1] : files
  end

  def get_articles_from_xml_file(file)
    text = File.read(file)
    Nokogiri::XML(text).xpath("//article[@id]")
  end

  def filter_match?(filter_type, article)
    filter_type.any? {   |field, value| value.index(article[field]) }
  end

  def filter_article(article, filter)
    return true if filter.empty?
    if filter[:exclude]
      return false if filter_match?(filter[:exclude], article)
    end

    return true if not filter[:include]
    filter_match?(filter[:include], article)
  end

  def return_0_if_empty(str)
    return '0' if str.empty?
    str
  end

  def process_article(article)
    desc = article.at('description')
    rank = article.at('rank')
    location = article.at('location')
    {
      #:url => article.at('url').text,
      #:charset => desc.attr('charset'),
      :title => desc.at('hltext_display').text,
      :language => desc.attr('language'),
      :article_id => article.attr('id').delete('_'),
      :content => desc.at('content').text,
#      :source => article.at('source').text,
#      :moreover_url => article.at('url').text,
#      :source_category => article.at('source_category').text,
#      :genre => article.at('genre').text,
#      :media_type => article.at('media_type').text,
#      :host => article.at('docurl').text,
#      :date => DateTime.parse( article.at('harvest_time').text).strftime('%FT%H:%M:%SZ'),
#      :rank_source => rank.at('source_rank').text.to_i,
#      :rank_web => rank.at('web_rank').text.to_i,
#      :rank_order => rank.at('order_rank').text.to_i,
#      :location_region => location.at('region').text,
#      :location_subregion => location.at('subregion').text,
#      :location_country => location.at('country').text,
    }
  end
end
