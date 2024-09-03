SRC = $(wildcard src/*.elm)

build: build/elm.js

build/elm.js: $(SRC)
	@echo "Compiling Elm files..."
	elm make src/Main.elm --output build/elm.js
