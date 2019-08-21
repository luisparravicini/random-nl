#!/usr/bin/env ruby -W

require 'open-uri'
require 'nokogiri'
require 'set'


next_urls = Queue.new
next_urls << URI.parse('https://en.wiktionary.org/wiki/Index:Dutch')
visited = Set.new

while !next_urls.empty? do
	url = next_urls.pop
	visited << url

	print '%s (%d queued)' % [url, next_urls.size]

	doc = Nokogiri::HTML(url.read)
	n = 0
	doc.search('a').each do |link|
		href = link['href']
		next if href.nil?

		next_url = URI.join(url, href)
		next unless next_url.path =~ %r{/wiki/Index:Dutch/}

		unless visited.include?(next_url)
			next_urls << next_url
			n += 1
		end
	end

	puts " [#{n} fetched]"
end
