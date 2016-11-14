class DSGet

attr_accessor :response

  def initialize(args)

    args.each do |k,v|
      instance_variable_set("@#{k}",v) unless v.nil?
    end

    @html_header =  {
    'Accept' => "application/json",
    'Content-Type' => "application/json",
    'X-DocuSign-Authentication' => {
      Username: @username,
      Password:  @password,
      IntegratorKey: @integratorkey
      }.to_json
    }
  end

  def login
    ds_get('/login_information/')
  end
  
  def unsupported_file_types
    ds_get('/unsupported_file_types/')
  end

  def groups
    ds_get("/groups/")
  end

  def folders
    ds_get("/accounts/#{@account_id}/folders")
  end

  def envelopes
    query = [['from_date', '2016-06-01+12:00'], ['status', 'sent']]
    ds_get("/envelopes", query)
  end

  def env_status(folder_id)
    ds_put("/folders/#{folder_id}")
  end

  def link(api_ref)
    ds_get(api_ref)
  end

private
  def ds_put(api_ref, api_query=nil)
    http, uri = request_header(api_ref)
    request = Net::HTTP::Put.new(uri.request_uri, @html_header )
    reply = http.request(request)
    @response = JSON.parse(reply.body, {symbolize_names: true})
  end

  def ds_get(api_ref, api_query=nil)
    http, uri = request_header(api_ref)
    
    unless api_query.nil?
      new_query = URI.decode_www_form(uri.query || '') + api_query
      uri.query = URI.encode_www_form(new_query)
    end 
    request = Net::HTTP::Get.new( uri.request_uri, @html_header )
    reply = http.request(request)
    @response = JSON.parse(reply.body, {symbolize_names: true} )
  end

  def request_header(api_ref)
    # Instance a URI
    uri = URI.parse(@url+api_ref) 
    uri_params = {
      api_password: false,
      include_account_id_guid: false,
      login_settings: 'none'
      }
    uri.query = URI.encode_www_form(uri_params)
    
    #Open SSL 
    http = Net::HTTP.new(uri.hostname, uri.port)
    http.use_ssl = uri.scheme == 'https'
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    #http.set_debug_output $stderr
    return http, uri
  end

end