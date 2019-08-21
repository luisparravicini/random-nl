#!/usr/bin/env ruby -W

require 'open-uri'
require 'nokogiri'
require_relative 'lib/data_store'


dump = (ARGV.shift == '-d')
dir = File.join(File.dirname(__FILE__), 'data')
store = DataStore.new(dir)

if dump
	puts 'urls to visit:'
	puts store.to_visit
	puts "\nvisited urls:"
	puts store.visited
	puts "\nwords:"
	puts store.words
	exit 0
end

first_url = 'https://en.wiktionary.org/wiki/Index:Dutch'
unless store.visited.include?(first_url)
	store.to_visit << first_url
end

puts "urls: %d fetched, %d to visit. %d words" %
	[store.visited.size, store.to_visit.size, store.words.size]

n = 0
while !store.to_visit.empty? do
	url = store.to_visit.delete_at(0)
	store.visited << url

	print '%s (%d queued, %d words)' %
		[url, store.to_visit.size, store.words.size]

	doc = Nokogiri::HTML(URI.parse(url).read)
	doc.search('a').each do |link|
		href = link['href']
		next if href.nil?

		begin
			next_url = URI.join(url, href)
		rescue URI::InvalidURIError => e
			print "\n\tERROR: #{e.message}"
			next
		end

		if next_url.fragment == 'Dutch'
			word = link.content.strip
			store.words[word] = next_url
		end

		next unless next_url.path =~ %r{/wiki/Index:Dutch/}

		next_url.fragment = nil

		next_url = next_url.to_s
		unless store.visited.include?(next_url)
			store.to_visit << next_url
		end
	end

	puts

	n += 1
	if n > 20
		print 'saving...'
		store.save
		puts
		n = 0
	end
end

store.save
