require_relative '../n_gram_generator'
require_relative 'moreover_xml_file_reader'


class LanguageClassifier

  TRAINING_DATA = File.dirname(__FILE__) + '/language_data.bin'

  def initialize ()
    @generator  = NGramGenerator.new
    @category_sums = Hash.new(0)

   if File.exist?(TRAINING_DATA)
     @categories = File.open(TRAINING_DATA, 'r') {|file| Marshal.load(file)}
   end
    show_distribution
  end

  def show_distribution
    @categories.each {|lan,dist|   puts " #category #{lan} has #{dist.keys.length} items sum keys: #{dist.values.inject(0) {|sum, element| sum+element}}"}
  end



  def load_training_data
      count =0
      @categories = Hash.new(0)
      MoreoverXmlFileReader.new( File.dirname(__FILE__)+ '/moreover/*.xml' ).get_documents.each do |doc|
        text = extract_text doc
        ngrams = generate_bi_and_tri_grams text
        ngrams.flatten.each {|gram, frequency|  train(language(doc), gram, frequency) }
        count +=1
      end

      puts "done loading data for #{count} documents, saving file"
      File.open(TRAINING_DATA, 'wb') {|file| Marshal.dump(@categories,file)}
    show_distribution
  end

  def extract_text(doc)
     doc[:title] = ' ' + doc[:content]
   end
  def language(doc)
     doc[:language]
   end

  def normalize_data

  end

  def has_language?(language)
    @categories.has_key? language
  end

  def add_language(language)
    category = language.prepare_category_name
    @categories[category] = Hash.new(0)
  end

  def train(language, feature, feature_count)

    unless feature.is_a?  String
      puts  "Should not happen: feature=> #{feature}"
      raise "ArgumentError('feature')"
    end

    unless feature_count.is_a? Fixnum
      puts  "Should not happen feature_count=> #{feature_count}"
      raise ArgumentError
    end
    
      language = language.prepare_category_name
      add_language(language) unless has_language? language
      puts language
      puts has_language? language
      @categories[language][feature] ||= 0
			@categories[language][feature] += feature_count
      @total_words += feature_count
  end

  def classifications(text)

    features = []
    ngrams = generate_bi_and_tri_grams text

          ngrams.flatten.each do |gram, frequency|
            features << gram
          end

    puts ngrams

		score = Hash.new
		@categories.select{|name,distribution| distribution.keys.length > 1000}.each do |category, category_words|
			score[category.to_s] = 0
			total = category_words.values.inject(0) {|sum, element| sum+element}


      features.each do |word|
				s = category_words[word]
        s += 0.001
				score[category.to_s] += Math.log(s/total.to_f)
			end
		end
		return score.sort_by { |a| -a[1] }
	end

  def generate_bi_and_tri_grams(text)
    @generator.parse(text)
  end

end

c = LanguageClassifier.new()
c.load_training_data

test = {
    :french    => "Birger il est trop fort en programmation.",
    :norwegian => 'hei dette er test av noe bra'
}

test.each do |facit, text|
  puts "#{text} is classified as #{c.classify(text)} when it is: #{facit}"
end


test.each do |facit, text|
  puts "#{text} is classified as #{c.classifications(text)} when it is: #{facit}"
end

#Classifier::Bayes.new().classifications

