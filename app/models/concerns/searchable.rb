module Searchable
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
    mapping do
        indexes :body, type: :text, analyzer: 'english'
    end

    def self.search(query)
        params = {
          query: {
            multi_match: {
              query: query,
              fields: ['body'],
              fuzziness: "AUTO"
            }
          }
        }
        self.__elasticsearch__.search(params).records.to_a
      end
end