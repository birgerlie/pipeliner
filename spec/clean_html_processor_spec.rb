require "rspec"
require_relative '../processors/clean_html_processor'

describe "CleanHtmlProcessor" do
  before do
    @cleaner = Indexer::CleanHtmlProcessor.new(:html)
    @html    = '<html><head><meta http-equiv="Content-Language" content="no-bok"><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><title>Sooft Meals</title></head><body background="images/bg.jpg"><div align="center">dette er test</body><html>'
  end
  describe "#html2text" do

    it "result should contain 3 keys" do
      result = @cleaner.html2text(@html)
      result.count.should == 3
      result.keys.should == [:html_title, :html_meta, :html_text]
    end

    {
      "javascript"=>"<html><body><script type='text/javascript'>//<![CDATA[CavalryLogger=false;window._is_quickling_index='';window._EagleEyeSeed='PUE5';//]]></script><noscript> <meta http-equiv=refresh content='0; URL=/?sk=events&amp;_fb_noscript=1' /> </noscript>javascript</body><html>"
    }.each do |expected, input|
      it "should clean javascript" do
        result = @cleaner.html2text(input)
        result[:html_text].gsub(' ', '').should == expected
      end
    end

    it "should have a result where the key :html_text should contain a clean text" do
      result = @cleaner.html2text(@html)
      result[:html_text].should == "dette er test"
    end



    it "should extract the page title into :html_title" do
      result = @cleaner.html2text(@html)
      result[:html_title].should =='Sooft Meals'
    end


    it "should extract the meta info into :html_meta" do
      result = @cleaner.html2text(@html)
      result[:html_meta].should_not == ''
    end


  end

  describe "#process" do
    it "should not return nil" do
      (@cleaner.process({}).is_a? Hash).should == true
      
    end

    it "should raise Argument error unless given a Hash" do
      lambda {@cleaner.process([])}.should raise_error ArgumentError
      lambda {@cleaner.process(4)}.should raise_error ArgumentError
      lambda {@cleaner.process('this should never happen')}.should raise_error ArgumentError
    end

    it "should return document with 3 keys added" do
      document = @cleaner.process({:html=>@html})
      document.keys.count.should == 4
    end

it "should add 3 keys to the dictionary" do
      doc = {:html=>@html,:some=>'other', :this=>:that }
      key_count = doc.keys.length
      document = @cleaner.process(doc)
      document.keys.count.should == 3+key_count



    end



  end

end