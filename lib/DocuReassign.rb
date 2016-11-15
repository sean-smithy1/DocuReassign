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

  # Envelopes with a particular user    
  envelopes_pending_signer = Hash.new
  email_to_find="anjanasathyan7955@gmail.com"

  env=DSGet.new(args)
  env.env_sent # All DS Envelopes with Sent Status
  
  env.response[:envelopes].each do |envelope|
    puts envelope[:envelopeId]
  
    rec=DSGet.new(args)
    # Get envelopes that have the receipient in question and routing order etc.
    # build a hash {envid:{rec_detail},envid:{rec_detail}}
    valid_rec = rec.env_recipients(envelope[:recipientsUri], email_to_find)
    envelopes_pending_signer[envelope[:envelopeId].to_sym]={}
    if valid_rec
      valid_rec.each do |element|
        envelopes_pending_signer[envelope[:envelopeId].to_sym].merge!({ 
          :recipientId => element[:recipientId], 
          :recipientIdGuid => element[:recipientId], 
          :routingOrder => element[:routingOrder] 
          })
      end
    end
  end
  # Itterate Hash to change relivent envelopes

end
