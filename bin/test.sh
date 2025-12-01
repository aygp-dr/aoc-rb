#!/bin/bash
#!/bin/bash
# Run tests for a specific day or year

if [ -z "$1" ]; then
  rspec
elif [ -z "$2" ]; then
  rspec "$1/"
else
  YEAR=$1
  DAY=$(printf "%02d" $2)
  rspec "${YEAR}/day${DAY}/spec/"
fi
