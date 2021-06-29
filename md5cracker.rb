#!/usr/bin/env ruby

# requires
require 'digest/md5'
require 'net/http'

class Md5Cracker
    
    def initialize(filename)
        @hashes = Array.new
        @cache = Hash.new

        File.new(filename).each_line do |line|
            if m = line.chomp.match(/\b([a-fA-F0-9]{32})\b/)
                @hashes << m[1]
            end
        end
        @hashes.uniq!
        puts "Loaded #{@hashes.count} unique hashes"

        load_cache
    end

    def crack
        @hashes.each do |hash|
            if plaintext = @cache[hash]
                puts "#{hash}:#{plaintext}"
                next
            end
            