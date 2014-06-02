# Fetch desk translations from localeapp and pushes them

class Syncer

  require 'clicrdv_translations'

  class << self

    def sync!

      localeapp.translations.each do |locale, translations|

        # Upload article translations
        translations['articles'].each do |article_id, translations|
          Desk.update_article_translations(article_id.to_i, locale, translations)
        end

        # Upload topic translations
        translations['topics'].each do |topic_id, translations|
          Desk.update_topic_translations(topic_id.to_i, locale, translations)
        end

      end

    end


    def localeapp
      @localeapp ||= ClicRDV::Translations.new(ENV['LOCALEAPP_API_KEY'], File.join(ROOT_DIR, '.tmp'))
    end

  end

end