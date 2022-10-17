install:
	bundle install
	rails db:drop db:create db:migrate
runserver:
	rails s