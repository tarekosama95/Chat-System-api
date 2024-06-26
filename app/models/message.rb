class Message < ApplicationRecord
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
    belongs_to :chat

    mapping do
        indexes :body, type: :text, analyzer: 'english'
    end

    def self.search(query)
        params = {
          query: {
            wildcard: {
             body:{
                value: "*#{query}*"
             }
            }
          }
        }
        self.__elasticsearch__.search(params).records.to_a
      end
end
