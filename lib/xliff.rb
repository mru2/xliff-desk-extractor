require 'builder'

# Stolen from https://github.com/zigomir/transync/blob/master/lib/transync/xliff_trans/xliff_trans_writer.rb
class Xliff

  # Translations hash is
  # [
  #   {
  #     :id => the article id,
  #     :texts => {
  #       :subject  => subject_s
  #       :body     => body_s
  #       :keywords => keywords_s
  #     } 
  #   }
  # ]
  def initialize(translations)
    @translations = translations
  end

  def xml
    xml = Builder::XmlMarkup.new( :indent => 4 )
    xml.instruct! :xml, :encoding => 'UTF-8'
    xml.xliff :version => '1.2', :xmlns => 'urn:oasis:names:tc:xliff:document:1.2' do |xliff|

      @translations.each do |article|

        xliff.file :'source-language' => 'fr-FR', :datatype => 'plaintext', :original => article[:id] do |file|
          file.body do |body|

            article[:texts].each do |key, value|
              body.tag! 'trans-unit', :id => key do |trans_unit|
                trans_unit.source value, :'xml-lang' => 'fr-FR'
              end
            end

          end
        end

      end

    end

    xml
  end


  # Returns a nested hash
  # {
  #   <article_id> => {
  #     (subject|body|text) => translated_value
  #   }
  # }

  def self.parse(raw)
    doc = Nokogiri::XML raw

    articles = {}

    doc.xpath('//xmlns:file').each do |article|

      begin
        article_id = article['original'].match(/Article#(\d+)/)[1].to_i
      rescue => e
        puts "Error fetching article id for #{article}"
        next
      end

      article_translations = {}

      article.xpath('.//xmlns:target').each do |translation|

        begin
          key = translation.parent['id']
          value = translation.text
          next if value == ''
        rescue => e
          puts "Error fetching translation infos for #{translation}"
          next
        end

        article_translations[key] = value

      end

      articles[article_id] = article_translations

    end

    articles

  end

end