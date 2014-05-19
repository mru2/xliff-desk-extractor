module DeskArticles

  class << self

    # Get a page from desk
    def get_page(page = 1)
      response = HTTParty.get(
        "https://clicrdv.desk.com/api/v2/articles?page=#{page}&per_page=100", 
        :basic_auth => {
          :username => ENV['DESK_LOGIN'], 
          :password => ENV['DESK_PASSWORD']
        },
      )

      return response.parsed_response['_embedded']['entries']
    end


    # We know we have 137 articles, fetch only the first 2 pages
    def all
      articles = (1..2).map{|page|get_page(page)}.flatten.map do |article_fields|
        format_article(article_fields)
      end
    end


    # Format a result
    def format_article(fields)
      id = fields['_links']['self']['href'].match(/\/api\/v2\/articles\/(\d+)/)[1].to_i
      Hashie::Mash.new(fields.merge(:id => id))
    end


    # Update the translations for an article
    def update_article_translations(article_id, locale, translations)

      puts "Updating #{locale} translations for article ##{article_id}"

      # Tries a PATCH to update an existing translation
      res = HTTParty.patch(
        "https://clicrdv.desk.com/api/v2/articles/#{article_id}/translations/#{locale}",
        :basic_auth => {
          :username => ENV['DESK_LOGIN'],
          :password => ENV['DESK_PASSWORD']
        },
        :headers => {
          'Content-Type' => 'application/json', 
          'Accept' => 'application/json'
        },
        :body => translations.to_json
      )

      return true if res.success?


      # If not working, tries a POST to create it
      res = HTTParty.post(
        "https://clicrdv.desk.com/api/v2/articles/#{article_id}/translations",
        :basic_auth => {
          :username => ENV['DESK_LOGIN'],
          :password => ENV['DESK_PASSWORD']
        },
        :headers => {
          'Content-Type' => 'application/json', 
          'Accept' => 'application/json'
        },
        :body => translations.merge(:locale => locale).to_json
      )

      return res.success?
    end

  end

end
