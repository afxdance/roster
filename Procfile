# https://devcenter.heroku.com/articles/getting-started-with-rails5#webserver
web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
# https://mentalized.net/journal/2017/04/22/run-rails-migrations-on-heroku-deploy/
release: bundle exec rake db:migrate
