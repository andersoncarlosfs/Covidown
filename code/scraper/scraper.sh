#!/bin/bash

for i in {1..809}; do
	curl https://assets.pokemon.com/assets/cms2/img/pokedex/full/$(printf '%03d' $i).png --output ../pokedex/assets/images/pokemons/$i.png
done
