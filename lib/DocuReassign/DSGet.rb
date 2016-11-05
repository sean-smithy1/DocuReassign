class DSGet

attr_accessor :response

  def initialize()
    @account_id = '72de1146-52e1-4375-ab33-9bda60bd059d' #(Basha)
    #@account_id='c988d19f-fa7c-4fbf-999e-432f717c99d9' #(Sean)
    #@account_id='c988d19f-fa7c-4fbf-999e-432f717c99d9' #(DocWorkflow)

    @url='https://demo.docusign.net/restapi/v2'
    @username='debasish.harshavardhan.das@outlook.com'
    @password='Password1'
    @integratorkey='DEBA-55a5b90b-c2e0-4943-b7ad-b098891505eb'

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
    ds_request('/login_information/')
  end

  def groups
    ds_request("/accounts/#{@account_id}/groups/")
  end



private
  def ds_request(api_ref)
    # Instance a URI
    uri=URI.parse(@url+api_ref)
    
    uri_params= {
      api_password: false,
      include_account_id_guid: false,
      login_settings: 'none'
      }
    
    uri.query = URI.encode_www_form(uri_params)

    #Open SSL 
    http = Net::HTTP.new(uri.hostname, uri.port)
    http.use_ssl = uri.scheme == 'https'
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    # http.set_debug_output $stderr
    
    #Send Request
    request = Net::HTTP::Get.new( uri.request_uri, @html_header )
  
    #Get Reply
    reply = http.request(request)
    
    #Set Response
    @response=JSON.parse(reply.body, {symbolize_names: true})
  
  end
end