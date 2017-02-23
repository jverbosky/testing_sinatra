# ru in config.ru - possibly "rack up", need to research


require './app'
# run Sinatra::Application  # doesn't work because app uses a class
run PersonalDetailsApp  # corresponds to class in app.rb

# run PersonalDetailsApp.run!  # this is how Caleb's config.ru has line 6