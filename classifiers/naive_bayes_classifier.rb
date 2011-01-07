require_relative 'classifier'
module Indexer
  module Classifiers
    class NaiveBayesClassifier < Classifier
      def initialize()
        super()
      end

      def classifications(features)
        total_score = Hash.new(0)

        @categories.each do |category,category_features|
          input_feature_score = features.inject(0) {|score, input_feature| category_features.has_key?input_feature ? score + category_features[input_feature] : score + 0.001 }
          total_score[category] = input_feature_score/Math.log(@categories_totals[category])
        end
        total_score
      end

      def train(category, features = [])
        features = decorate_features features
        add_category(category) unless categories.any? category
        features.each {|feature| @categories[category][feature] +=1; @categories_totals[category]+=1}
      end

      def category_probability(feature)
        @categories.map{|category| category.has_key? feature ? category[feature]:0 }
      end
    end
  end
end

nb = Indexer::Classifiers::NaiveBayesClassifier.new
nb.train(:bad, 'fuck shit cunt pussy anal fist fuck'.split(' '))
nb.train(:good, 'nice good excellent sweet great'.split(' '))

nb.classifications('this is some good shit')