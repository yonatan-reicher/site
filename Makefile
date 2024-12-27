SRC = $(wildcard src/*.elm)

build: build/elm.js

debug:
	@echo "Compiling Elm files... in debug mode!"
	elm make src/Main.elm --output build/elm.js --debug

build/elm.js: $(SRC)
	@echo "Compiling Elm files..."
	elm make src/Main.elm --output build/elm.js

clean:
	@echo "Cleaning up..."
	rm -f build/elm.js

.PHONY: build clean debug
