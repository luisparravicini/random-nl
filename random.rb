#!/usr/bin/env ruby -W

require 'open-uri'
require 'nokogiri'
require_relative 'lib/data_store'


dir = File.join(File.dirname(__FILE__), 'data')
store = DataStore.new(dir)

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
