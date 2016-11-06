class DSGet

attr_accessor :response

  def initialize()
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

  def groups
    ds_get("/accounts/#{@account_id}/groups/")
  end

  def folders
    ds_get("/accounts/#{@account_id}/folders")
  end

  def envelopes
    ds_get("/accounts/#{@account_id}/envelopes")
  end

  def env_status(FolderID)
    ds_put("/accounts/#{@account_id}/folvers/#{folderID}")
  end

private
  def ds_put(api_ref, api_query=nil)
    http, uri = request_header(api_ref)
    request = Net::HTTP::Put.new(uri.request_uri, @html_header )
    request.body = 
    reply = http.request(request)
    @response=JSON.parse(reply.body, {symbolize_names: true})
  end

  def ds_get(api_ref, api_query=nil)
    http, uri = request_header(api_ref)
    request = Net::HTTP::Get.new( uri.request_uri, @html_header )
    reply = http.request(request)
    @response = JSON.parse(reply.body, {symbolize_names: true})
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