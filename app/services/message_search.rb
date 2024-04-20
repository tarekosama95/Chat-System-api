class MessageSearch
    def initialize (search)
        @search_param = search
    end
    def call
        Message.search(
            query:{
                bool:{
                    must:[
                        {match: {chat_id: @search_param}},
                        {wildcard: {body: "*#@search_param*"}}
                    ]
                }
            }
        )
        end
    end