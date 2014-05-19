require './env.rb'

articles = DeskArticles.all

# Map the articles
source_translations = articles.map do |article|
  {
    :id => "Article##{article.id}",
    :texts => {
      :subject  => article.subject,
      :body     => CGI.unescapeHTML(article.body_email), # Virtually the same as phone, facebook, qna, ...
      :keywords => article.keywords,
    }
  }
end

# Format them in xliff
xliff = Xliff.new(source_translations)
xml = xliff.xml

# Write them to the output file
File.open('./translations.xlf', 'w') { |file| file.write(xml.target!) } # target*!* to not append </target> at the end of the file

puts "Saved translations file in #{Dir.pwd}/translations.xlf"