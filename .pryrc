# Pry.config.editor = "vim --nofork"

# Print Ruby version at startup
Pry.config.hooks.add_hook(:when_started, :say_hi) do
  puts "Using Ruby version #{RUBY_VERSION}"
end

# Require Sinatra application
require './app'

def reload!
  AUTOLOAD_PATHS.each do |dir|
    ::Dir.glob(::File.expand_path("../#{dir}", __FILE__) + '/**/*.rb').each do |file|
      load file
    end
  end
end