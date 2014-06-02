# Import the desk translations into .yml files
class Importer
  class << self


    def articles_translations
      res = {}

      articles = Desk.articles
      articles.each do |article|

        puts "Fetching translations of article ##{article.id}"

        translations = Desk.get("/articles/#{article.id}/translations")

        if !translations
          puts "Error fetching translations for article #{article.id} - #{article.subject}"
          next
        end

        translations.each do |translation|

          locale = translation.locale[0...2]
          res[locale] ||= {}
          res[locale][article.id] = {
            'subject' => translation.subject,
            'body' => translation.body
          }

        end

      end

      res
    end


    def topics_translations
      res = {}
      
      topics = Desk.topics
      topics.each do |topic|

        puts "Fetching translations of topic #{topic.id}"

        translations = Desk.get("/topics/#{topic.id}/translations")

        if !translations
          puts "Error fetching translations for topic #{topic.id} - #{topic.name}"
          next
        end

        translations.each do |translation|
          locale = translation.locale[0...2]
          res[locale] ||= {}
          res[locale][topic.id] = {
            'name' => translation.name
          }
        end

      end

      res
    end

  end
end