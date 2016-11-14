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

  env=DSGet.new(args)
  env.envelopes
  count = 0
  env.response[:envelopes].each { |env|
    count += 1
    puts env[:envelopeId]
    rec = DSGet.new(args)
    rec.link(env[:recipientsUri])
    rec.response[:signers].each { |signer|
    string = "\t#{signer[:name]}, #{signer[:status]}"
    
    if signer[:status] == 'sent'
      puts string + " *\n"
    else
      puts string + "\n"
    end
    }
    puts "\n"
  }
  puts "\n#{count.to_s} Envelopes Returned\n" 


env=nil

env2=DSGet.new(args)
env2.unsupported_file_types 



env2=nil

end
