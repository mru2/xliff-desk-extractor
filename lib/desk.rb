class Desk

  class << self

    AUTH = {
      :username => ENV['DESK_LOGIN'], 
      :password => ENV['DESK_PASSWORD']    
    }

    HOST = 'https://clicrdv.desk.com/api/v2'

    # HTTP methods
    [:get, :post, :patch].each do |method|
      define_method method do |path, content = {}|

        uri = "#{HOST}#{path}"
        uri += "?#{URI.encode_www_form(content)}" if method == :get

        opts = {}
        opts[:basic_auth] = AUTH
        opts[:header] = {
          'Content-Type' => 'application/json', 
          'Accept' => 'application/json'
        }

        opts[:body] = content.to_json if method != :get

        res = HTTParty.send(method, uri, opts)

        return false unless res.success?

        res = Hashie::Mash.new(res.parsed_response)

        # Handle collection results
        if res['_embedded'] && res['_embedded']['entries']
          return res['_embedded']['entries']
        else
          return res
        end
      end
    end


    def get_all(path, opts = {})
      pages = opts[:pages] || 1
      (1..pages).map{|page_nb|
        get(path, :page => page_nb, :per_page => 100)
      }.flatten
    end

    def articles
      get_all('/articles', :pages => 2).map do |article|
        format_article(article)
      end
    end

    def topics
      get_all('/topics').map do |topic|
        format_topic(topic)
      end
    end


    # Update the translations for an article
    def update_article_translations(article_id, locale, translations)

      puts "Updating #{locale} translations for article ##{article_id}"

      # Tries a PATCH to update an existing translation
      res = patch "/articles/#{article_id}/translations/#{locale}", translations
      return true if res != false


      # If not working, tries a POST to create it
      res = post "/articles/#{article_id}/translations", translations.merge(:locale => locale)
      return !!res
    end


    # Update the translations for a topic
    def update_topic_translations(topic_id, locale, translations)
      puts "Updating #{locale} translations for topic ##{topic_id}"

      # Tries a PATCH to update an existing translation
      res = patch "/topics/#{topic_id}/translations/#{locale}", translations
      return true if res != false


      # If not working, tries a POST to create it
      res = post "/topics/#{topic_id}/translations", translations.merge(:locale => locale)
      return !!res
    end


    # Get an article's id from its url
    def format_article(article)
      id = article['_links']['self']['href'].match(/\/api\/v2\/articles\/(\d+)/)[1].to_i
      article.id = id
      article
    end

    # Idem for a topic
    def format_topic(topic)
      id = topic['_links']['self']['href'].match(/\/api\/v2\/topics\/(\d+)/)[1].to_i
      topic.id = id
      topic
    end
 
  end 

end
