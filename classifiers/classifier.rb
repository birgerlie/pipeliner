module Indexer
  module Classifiers
    class Classifier
      attr_reader :categories, :threshold, :default_category, :feature_decorators
      OPTIONS_KEY = '__CLASSIFIER__PROPS__'
      def initialize
        @categories       = Hash.new(Hash.new())
        @categories_totals = Hash.new(0)
        @threshold        = 0.0
        @default_category = :unknown
        @feature_decorators = []
      end

      def add_category(category)
        @categories[category] = Hash.new(0)
      end

      def add_feature_decorator(decorator)
        raise ArgumentError unless decorator.respond_to? 'decorate'
        @feature_decorators << decorator
        @feature_decorators.count
      end

      def classify(features =[])
        result = classifications(features).sort_by { |a| -a[1] }.first
        if result[1] < @threshold
          @default_category
        else
          result[0]
        end
      end

      def classifications(features =[])
        raise NotImplementedError
      end

      def train(category, features =[])
        raise NotImplementedError
      end
      
      def read_training_set_from_file(file)
         {:threshold=>@threshold,:default_cat=>@default_category}.each {|k,v| options[k]=v}
        @categories[OPTIONS_KEY] = options

        features_and_options = File.open( file,'r') {|io| Marshal.open(io)}
        options = features_and_options[OPTIONS_KEY]
        features_and_options.delete(OPTIONS_KEY)
        @categories = features_and_options

        @threshold = options[:threshold]; options.delete(:threshold)
        @default_category = options[:default_cat] ; options.delete(:default_cat)

        options
      end

      def save_training_set_to_file(file, options = {})
        {:threshold=>@threshold,:default_cat=>@default_category,:decorators=>@feature_decorators}.each {|k,v| options[k]=v}
        @categories[OPTIONS_KEY] = options
        File.open( file,'wb') {|io| Marshal.dump(@categories,io)}

      end

      def decorate_features(features)
        feature_decorators.each {|decorator| features = decorator.decorate(features)  }
        features
      end
    end
  end
end