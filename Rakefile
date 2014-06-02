require './env.rb'

desc 'Export existing article translations in .yml files'
task :export_to_yaml do

  # Fetch translations
  articles_translations = Importer.articles_translations
  topics_translations = Importer.topics_translations

  # Merge them in a big hash and write it to disk
  %w(fr en de nl).each do |locale|

    full_hash = {
      'articles' => articles_translations[locale],
      'topics' => topics_translations[locale]
    }

    output = File.join(File.dirname(__FILE__), "#{locale}.yml")

    File.open(output, 'w') do |f|
      f.write ({locale => full_hash}).to_yaml
    end

  end

end 