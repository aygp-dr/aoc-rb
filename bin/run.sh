#!/bin/bash
#!/bin/bash
# Run a specific day's solution

YEAR=${1:-$(date +%Y)}
DAY=$(printf "%02d" ${2:-1})

cd "${YEAR}/day${DAY}" || exit 1
ruby solution.rb
