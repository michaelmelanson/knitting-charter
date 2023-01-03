build:
	sass views/style.sass public/style.css

dev: build
	bundle exec rackup -p 4567