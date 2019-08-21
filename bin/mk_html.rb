#!/usr/bin/env ruby -W

require 'json'
require_relative '../lib/data_store'


store = DataStore.new

words = store.words
if words.empty?
	puts "no words!"
	exit 1
end

base_uri = 'https://en.wiktionary.org/wiki/'
fragment = 'Dutch'
fname = 'random-word.html'
words_data = words.map do |word, url|
	unless url.fragment == fragment
		raise "unexpected fragment: #{url.fragment}"
	end
	url.fragment = nil
	url = url.to_s
	unless url.start_with?(base_uri)
		raise "unexpected url: '#{url}'"
	end

	url[base_uri.size..-1]
end

File.open(fname, 'w') do |io|
	io.write <<-HTML
	<html>
	<head>
		<style>
			#btn, #msg {
				font-family: sans-serif;
				display: inline-block;
			}
			#btn {
				padding: 0.4em;
				margin-right: 4em;
			}
		</style>
	</head>
	<body>
		<script>
			let fragment = '#{fragment}';
			let base_uri = '#{base_uri}';
			let words = #{words_data.to_json};

			function chooseWord() {
				let index = Math.floor(Math.random() * Math.floor(words.length));
				let word_url = base_uri + words[index] + '#' + fragment;

				let node = document.getElementById('msg');
				node.textContent = word_url;

				node = document.getElementById('wiktionary');
				node.src = word_url;
			}

			window.onload = function() {
				document.getElementById("btn").onclick = function(event) {
					chooseWord();
				}
				chooseWord();
			};
		</script>
		<button id="btn">Another word</button>
		<p id="msg"></p>

		<iframe id="wiktionary"
    height="800"
    style="width:100%"
    src="">
</iframe>

	</body>
	</html>
	HTML
end

puts "generated #{fname}"