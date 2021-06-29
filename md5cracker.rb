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
            if plaintext = crack_single_hash(hash)
                puts "#{hash}:#{plaintext}"
                append_to_cache(hash, plaintext)
            end
            sleep 1
        end

        private
        
        def crack_single_hash(hash)
            response = Net::HTTP.get URI("http://www.google.com/search?q=#{hash}")
            wordlist = response.split(/\s+/)
            if plaintext = dictionary_attack(hash, wordlist)
                return plaintext
            end
            nil
        end

        def dictionary_attack(hash, wordlist)
            wordlist.each do |word|
                if Digest::MD5.hexdigest(word) == hash.downcase
                    return word
                end
            end
            nil
        end
        