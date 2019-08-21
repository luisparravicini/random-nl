#!/usr/bin/env ruby -W

require_relative '../lib/data_store'


store = DataStore.new

words = store.words
if words.empty?
	puts "no words!"
	exit 1
end

index = rand(words.size)
word = words.keys[index]
url = words[word] 

puts word
puts url
`open "#{url}"`
