# Log parser

Brief for test is in the file `SP Test - Ruby.pdf`

# Requirements

To run the script you will need:

- ruby 2.7.2

# Usage

To run tests:

- `bundle install`
- `bundle exec rspec`

To parser logs:

`ruby parser.rb webserver.log`

Expected output:

```
Reading file: webserver.log
UniqueStrategy
/index 23 unique views
/home 23 unique views
/contact 23 unique views
/help_page/1 23 unique views
/about/2 22 unique views
/about 21 unique views
AllStrategy
/about/2 90 visits
/contact 89 visits
/index 82 visits
/about 81 visits
/help_page/1 80 visits
/home 78 visits
```

# Approach

- Spiked the file to see what the output might be
- Deleted spike and set out structure of project
- Installed rspec using bundler to start TDD approach
- Developed the `LogParser` object in spec file to read lines
- Pluralised output strings
- Extracted `LogParser` into it's own file when it was too large to work with in the spec file
- Got the skeleton of the parser working
- Extracted strategies for differing parser `Reports`
- Refactored `LogParser` to use strategies
- Extracted `LogExtractor` to read the log file
- Refactored `LogParser` to use `LogExtractor`
- Handle errors returned from reading log file
- Created entry point to the project to execute the `LogParser`
- Added missing requirement to sort the output
- Added README.md
