require 'set'
require 'fileutils'

class DataStore
	attr_reader :visited, :to_visit, :words

	def initialize(path)
		FileUtils.mkdir_p(path) unless File.directory?(path)
		@data_path = File.join(path, 'urls.bin')
		load
	end

	def save
		tmp_path = File.join(File.dirname(@data_path), 'tmp.db')
		File.open(tmp_path, 'w') do |io|
			Marshal::dump(@words, io)
			Marshal::dump(@to_visit, io)
			Marshal::dump(@visited, io)
		end
		FileUtils.mv(tmp_path, @data_path)
	end

	protected

	def load
		if File.exist?(@data_path)
			File.open(@data_path, 'r') do |io|
				@words = Marshal::load(io)
				@to_visit = Marshal::load(io)
				@visited = Marshal::load(io)
			end
		else
			@visited = Set.new
			@to_visit = Array.new
			@words = Hash.new
		end
	end

end
