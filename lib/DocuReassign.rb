#!/usr/bin/env ruby
module DocuReassign
  VERSION = '0.0.1'
  DATA_DIR =  './Data'

  require 'net/http'
  require 'json'
  require 'openssl'
  require 'open-uri'

  require_relative 'DocuReassign/DSGet'
  require_relative 'DocuReassign/utils'

  Utils.clear

  if Utils.internet? == false
    puts "Internet is required"
    exit
  end

  me=DSGet.new
  me.env_status('99f7d0f1-74e5-4ef8-8e10-deee58ce33ce')
  #me.folders
  puts JSON.pretty_generate(me.response)  

end
