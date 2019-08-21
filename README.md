README
======


`bin/fetch_words.rb` Creates a list of words from the [Wiktionary Dutch Index](https://en.wiktionary.org/wiki/Index:Dutch) and stores the information on disk.


`bin/random.rb` prints a random word from the list and tries to open the url to the entry (it uses `open` which is a macOS command).

`bin/mk_html.rb` creates a html file which takes you to a random word.


The scripts require Ruby (tested with 2.6)

[output/random-word.html](output/random-word.html) has the html output from the word list created on 2019-08-21
