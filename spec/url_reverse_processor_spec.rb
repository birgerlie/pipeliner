require "rspec"
require_relative '../processors/url_reverse_processor'

describe "UrlReverseProcessor" do
  before do
    @urls = {
        'http://no.vg.www'               =>'http://www.vg.no',
        'http://no.vg.www'               => 'www.vg.no',
        ''                               => 'some error',
        'http://no.vg.www/some_argument' => 'http://www.vg.no/some_argument',
        'http://no.vg.www/some_argument' => 'www.vg.no/some_argument',
    }

    @proc = Indexer::UrlReverseProcessor.new(:field=>:url)

  end

  describe "#process" do
    it "should return a hash" do
      (@proc.process({}).is_a? Hash).should == true
    end

    it "should return a hash" do
      (@proc.process({}).is_a? Hash).should == true
    end


  end

  describe "#reverse_url" do
    {
        'http://no.vg.www'                     =>'http://www.vg.no',
        'http://no.vg.www'                     => 'www.vg.no',
        ''                                     => 'some error',
        'http://no.vg.www/some_argument'       => 'http://www.vg.no/some_argument',
        'http://no.vg.www/some_other_argument' => 'www.vg.no/some_other_argument',
    }.each do |reverced_url, url|
      it "should reverse urls" do
        @proc.reverse_url(url).should == reverced_url
      end
    end

    [[],4,Time.now,34.3, {}].each do |illegal|
      it "should raise ArgumentError when not given String using #{illegal.class}" do
        lambda {@proc.reverse_url(illegal)}.should raise_error ArgumentError
      end
    end
  end

  describe "#reverse_host" do
    it "should reverse a domain name" do
      {
        'no.db.www'                     =>'http://www.db.no',
        'no.vg.www'                     => 'www.vg.no'
      }.each do |reverse, url|
        @proc.reverse_host(url).should == reverse
      end

    end

     [[],4,Time.now,34.3,{}].each do |illegal|
    it "should raise ArgumentError when not given String using #{illegal.class}" do
        lambda {@proc.reverse_host(illegal)}.should raise_error ArgumentError
      end
    end
  end

end

