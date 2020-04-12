build: app.js lib/routes.js lib/passport.js
app.js: index.coffee
	coffee -cp index.coffee > app.js
lib/routes.js: src/routes.coffee lib
	coffee -cp src/routes.coffee > lib/routes.js
lib/passport.js: src/passport.coffee lib
	coffee -cp src/passport.coffee > lib/passport.js
lib:
	mkdir lib
clean:
	rm -r lib app.js || true
.PHONY: default
default: build
.DEFAULT_GOAL := build
