#!/bin/bash
# List of files to safely modify (avoiding JSON to prevent syntax errors)
FILES=$(find . -type f -not -path '*/.*' -not -name "*.json" | grep -v "push_files.sh" | grep -v "padding_pushes.sh")

for i in {1..200}
do
  echo "Iteration $i/200..."
  for file in $FILES
  do
    # Determine comment style based on extension
    if [[ $file == *.js ]] || [[ $file == *.sh ]]; then
      echo "// Iteration $i: trivial update" >> "$file"
    elif [[ $file == *.yml ]] || [[ $file == *.yaml ]] || [[ $file == *.md ]] || [[ $file == *Dockerfile ]] || [[ $file == *Makefile ]]; then
      echo "# Iteration $i: trivial update" >> "$file"
    else
      echo "Iteration $i: trivial update" >> "$file"
    fi
  done
  
  git add .
  git commit -m "Iteration $i: trivial update to all files"
  git push origin HEAD:main
  
  # Small sleep to avoid hitting GitHub API limits too hard
  sleep 1
done
