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

        xliff.file :'source-language' => 'fr_FR', :datatype => 'plaintext', :original => "Article#{}" do |file|
          file.body do |body|

            article[:texts].each do |key, value|
              body.tag! 'trans-unit', :id => key do |trans_unit|
                trans_unit.source value
              end
            end

          end
        end

      end

    end

    xml
  end

end