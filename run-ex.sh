#!/bin/sh

DAY=$1
shift
PART=$1
shift

mix escript.build
npm run -s download "${DAY}"
echo "-------------"
./advent_of_code_2021 $DAY $PART < "data/input-${DAY}.txt"