require 'fileutils'

namespace :assets do
  desc 'create a static javascript translation file with each language available as a JSON object'
  task :generate_json_translations do
    languages = %w(de en zh-CN)
    key = 'front_end'
    assets_path = './public/locales/'
    FileUtils.mkdir_p(assets_path) unless Dir.exist?(assets_path)
    languages.each do |lang|
      file = File.new("#{assets_path}#{lang}.json", 'w')
      langfile = YAML.safe_load(File.open("config/locales/#{lang}.yml"))
      file.write(langfile[lang][key].to_json + "\n\n")
      file.close
    end
  end
end
