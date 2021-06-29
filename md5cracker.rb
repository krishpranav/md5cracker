#!/usr/bin/env ruby

# requires
require 'digest/md5'
require 'net/http'

class Md5Cracker
    
    def initialize(filename)
        @hashes = Array.new
        @cache = Hash.new