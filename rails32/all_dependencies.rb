

modules = %w(readme database sidekiq user twitter_bootstrap haml home_controller)

modules.each do |mod|
  require File.expand_path("../templates/#{mod}/#{mod}.rb", __FILE__)  
end


def ask_with_default(message, default)
  input = ask(message)
  input.present? ? input : default
end

def yes_or_blank?(message)
  input = ask("#{message} [y/n]:")
  input == "yes" || input == "y" || !input.present?
end

def read_file_and_gsub(source_file, targe_file, options = {})
  path = File.expand_path("../#{targe_file}", source_file)
  content = File.read(path)
  options.each do |key, value|
    content.gsub!(key.to_s, value)
  end
  content
end

