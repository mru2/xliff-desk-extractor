require './env.rb'

abort 'Please specify a translations file  and a language to import. e.g ruby import.rb en ./translations.xlf' if ARGV.count < 2

locale = ARGV[0].to_sym
file_path = ARGV[1]

puts "Importing [#{locale}] translations file #{file_path}..."

all_translations = Xliff.parse(File.open(file_path).read)

all_translations.each do |article_id, translations|
  success = DeskArticles.update_article_translations(article_id, locale, translations)

  if !success
    puts "Error updating translations for article ##{article_id}"
  end
end

