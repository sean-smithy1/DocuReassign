#!/usr/bin/env ruby
module DocuReassign
  VERSION = '0.0.1'
  DATA_DIR =  './Data'

  require 'net/http'
  require 'json'
  require 'openssl'
  require 'open-uri'
  require 'yaml'

  require_relative 'DocuReassign/DSGet'
  require_relative 'DocuReassign/utils'

  Utils.clear
  args = YAML.load_file('config/config.yaml')

  if Utils.internet? == false
    puts "Internet is required"
    exit
  end

  me=DSGet.new(args)
  me.envelopes
  #me.folders
  puts JSON.pretty_generate(me.response)  

end
