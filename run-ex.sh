#!/bin/sh

DAY=$1
shift
PART=$1
shift

npm run -s download "${DAY}"
mix run "src/puzzles/day${DAY}/part${PART}.exs" < "src/puzzles/day${DAY}/input.txt"