
class NGramGenerator
  def initialize ()

  end

  def parse(text)
    calculate_distribution(gramify(words_from_text(text)))
  end


  def words_from_text text
    if text.is_a? Array
      ret = []
      text.each {|sentence| ret << words_from_text(sentence)}
      return ret
    end

    unless text.is_a? String
      raise ArgumentError
    end
    text.scan(/[a-z]+/).flatten()
  end


  def gramify(text, n=2, delimiter = ' ')
    tokens = words_from_text text
    ret = []
    tokens.each_cons(n){|a| ret << a.join(delimiter) }
    ret
  end

  def calculate_distribution(ngrams = [])
    throw ArgumentError unless ngrams.is_a? Array
    distribution = Hash.new(0)
    ngrams.collect {|gram| distribution[gram]+=1}
    distribution
  end

#FeatureDecorator implementation
  def decorate(text =[], n=2,delimiter=' ')
    
    text = [text] if text.is_a? String
    ret = []
    text.each{|sentence| ret << gramify(sentence,n,delimiter)}
    ret
  end
end

#
#text = "hei birger dette er en test er er er er "
#n= NGramGenerator.new
#p n.parse ''
#p n.calculate_distribution(n.gramify(text))
#p n.decorate text

