require "rspec"
require_relative "../classifiers/classifier"
require_relative "../classifiers/feature_decorator"

describe "Classifier" do
  include Indexer::Classifiers
  before do
    @cfy = Classifier.new
  end

  describe "#add_decorator" do
    it "should raise argument exception unless decorator responds to decorate" do
      lambda { @cfy.add_feature_decorator([]) }.should raise_error ArgumentError
    end

    it "should store decorators in sequence" do
      decorator = FeatureDecorator.new()
      @cfy.add_feature_decorator(decorator)
      @cfy.feature_decorators[0].should == decorator
      another_decorator = FeatureDecorator.new()
      @cfy.add_feature_decorator(another_decorator)
      @cfy.feature_decorators[0].should == decorator
      @cfy.feature_decorators[1].should == another_decorator
    end
  end

  describe "#limit" do
    

  end



end