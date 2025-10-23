SRC = $(wildcard src/*.elm)

build: $(SRC)
	@echo "Compiling Elm files..."
	elm make src/Home.elm --output=index.html
	elm make src/Projects.elm --output=projects.html

.PHONY: build
