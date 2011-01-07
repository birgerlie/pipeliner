require "rspec"
require_relative '../classifiers/n_gram_generator'


describe NGramGenerator do
  before do
    @parser = NGramGenerator.new
    @text = 'hey this is some testing of ngram of ngram'
  end

  describe "#parse" do
    it "should return an array" do
      @parser.parse('').class == Array
    end

    it "should return have 2 items" do
      @parser.parse('').length.should == 0
    end

    it "each item should be a Hash" do
      @parser.parse("this is some text")[0].class == Hash
      @parser.parse("this is some text")[1].class == Hash

    end

    it "bigram should split 2 words into 1 gram" do
      text   = "this text"

      result = @parser.parse(text)
      result.values.count.should == 1
      result.keys[0].should == text
    end

    it "bigram should split 3 words into 2 gram" do
      text   = "this is text"

      result = @parser.parse(text)

      result.values.count.should ==2
      result.keys[0].should == 'this is'
      result.keys[1].should == 'is text'
    end

    it "should give the right frequencies for bi_grams and tri_grams" do
      text = 'it is it is this is'
      text2 = 'this is it, this is it yeeha'
      @parser.parse(text)['it is'].should == 2
    end
  end

  describe "#words_from_text" do
    it "should split strings in to an array of strings" do
      @parser.words_from_text(@text).class.should == Array
      @parser.words_from_text(@text).join(' ').should == @text
    end

    it "should split arrays of strings into arrays of string-arrays " do
      text_arr = ['welcome to the', 'jungle we have fun and games']
      @parser.words_from_text(text_arr).count.should == 2
      @parser.words_from_text(text_arr)[1].count.should == 6
      @parser.words_from_text(text_arr)[0].count.should == 3
    end

    it "will raise argument error of given input other than string or array of string" do
      lambda{@parser.words_from_text({:this=>"will go wrong"})}.should raise_error ArgumentError
    end
  end

  describe "#gramify" do
    it "should split sentences in to ngrams" do
      @parser.gramify('this is').count.should == 1
      @parser.gramify('this is the').count.should == 2
      @parser.gramify('this is the end').count.should == 3

      @parser.gramify('this is the end')[0].should == 'this is'
      @parser.gramify('this is the end')[1].should == 'is the'
    end
    it "should split sentencens into to ngrams og n size" do
      @parser.gramify('this is the',3).count.should == 1
      @parser.gramify('this is the end',3).count.should == 2
    end
    it "should split sentencens into to ngrams with separator" do
      @parser.gramify('this is the',2,'-')[0].should == 'this-is'
    end
  end

  describe  "#calculate_distribution" do
    it "should return a hash" do
      ngram = @parser.gramify(@text)
      @parser.calculate_distribution(ngram).class.should == Hash
    end
    it "should return a hash with the right distibution of ngrams in array" do
      ngram = @parser.gramify('this is the end, my friend the end')
      @parser.calculate_distribution(ngram)['the end'].should ==2
      @parser.calculate_distribution(ngram)['this is'].should ==1
      @parser.calculate_distribution(ngram)['my friend'].should ==1
      @parser.calculate_distribution(ngram)['some other text'].should ==0
    end

    it "should throw ArgumentError if given other input than array" do
      lambda{@parser.calculate_distribution({:this=>"will go wrong"})}.should raise_error ArgumentError
      lambda{@parser.calculate_distribution(nil)}.should raise_error ArgumentError
    end

  end

  describe "#decorate" do
    it "should respond to decorate" do
      (@parser.respond_to? :decorate).should == true
    end
    it "should split words into text and return array of ngrams" do
      @parser.decorate('this is').count.should == 1
    end

    it "should split arrays words into text and return array of ngrams" do
      @parser.decorate(['this is']).count.should == 1
    end
  end
end

