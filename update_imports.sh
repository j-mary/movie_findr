#!/bin/bash

# Script to update all import statements from movie_flow to movie_findr

# Navigate to the project directory
cd /Users/jmo/dev-projects/Others/movie_flow

# Find all Dart files and update the import statements
find lib -name "*.dart" -type f -exec sed -i '' 's/import '\''package:movie_flow\//import '\''package:movie_findr\//g' {} \;

echo "All import statements have been updated from movie_flow to movie_findr."
