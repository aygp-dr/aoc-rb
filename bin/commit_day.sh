#!/bin/bash
#!/bin/bash
YEAR=$1
DAY=$(printf "%02d" $2)

git add "${YEAR}/day${DAY}/"
git commit -m "Add ${YEAR} Day ${DAY} solution

⭐ Part 1 complete
⭐ Part 2 complete"
