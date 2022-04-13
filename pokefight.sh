#!/usr/bin/env bash

# Usage example: `./pokefight.sh charmander squirtle`

pokemon1=${1}
pokemon2=${2}

# Checks if exactly 2 Pokemons are provided
if [[ $# != 2 ]]; then
  echo "ERROR: Exactly 2 Pokemon names must be provided"
  exit 1
fi

# Check if the requested Pokemons are different
if [[ ${pokemon2} == "${pokemon1}" ]]; then
  echo "ERROR: The requested Pokemons must be different"
  exit 1
fi

# We make sure our environment is ready
if ! command -v jq &>/dev/null; then
  echo "ERROR: Dependency 'jq' could not be found"
  exit 1
fi

# Gets the Pokemon's attack information from the API
# @param {string} pokemonName
# @return {string} pokemonAttackNumber
getPokemonAttack() {
  pokemonData=$(curl -f -s "https://pokeapi.co/api/v2/pokemon/${1}")
  if [ $? != 0 ]; then
    echo "ERROR: Could not get Pokemon '${1}' data from the API"
    exit 1
  fi

  echo "${pokemonData}" | jq '.stats[] | select(.stat.name=="attack") | .base_stat'
}

pokemonAttack1=$(getPokemonAttack "${pokemon1}")
pokemonAttack2=$(getPokemonAttack "${pokemon2}")

echo "${pokemon1} (${pokemonAttack1}) vs ${pokemon2} (${pokemonAttack2})"

if [[ ${pokemonAttack1} > ${pokemonAttack2} ]]; then
  echo "${pokemon1} wins!"
elif [[ ${pokemonAttack1} == "${pokemonAttack2}" ]]; then
  echo "It's a tie!"
else
  echo "${pokemon2} wins!"
fi
