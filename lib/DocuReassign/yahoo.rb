class Yahoo

HOST = "https://query.yahooapis.com/v1/public/yql?q="
OPTIONS = "&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="

  def initalize ()

  end

  def get_industries
    query=URI.encode( "SELECT * FROM yahoo.finance.sectors" )
    url="#{HOST}#{query}#{OPTIONS}"
    begin
      yql_return=JSON.parse(Net::HTTP.get_response(URI.parse(url)).body, symbolize_names: true)
    rescue
      print "Connection error."
    end
    yql_return[:query][:results]
  end

  def companies_by_industry(id)
    query=URI.encode("SELECT * FROM yahoo.finance.industry WHERE id = #{id} AND company.symbol MATCHES '^[A-Z]{3,4}$'")
    url="#{HOST}#{query}#{OPTIONS}"
    begin
      yql_return=JSON.parse(Net::HTTP.get_response(URI.parse(url)).body, symbolize_names: true)
      yql_return[:query][:results][:industry][:company]
    rescue
      print "Connection error."
    end
  end


  def industry_company_cashflow(id)
    query=URI.encode("SELECT * FROM yahoo.finance.cashflow WHERE symbol IN (SELECT company.symbol FROM yahoo.finance.industry WHERE id = '#{id}' AND company.symbol MATCHES '^[A-Z]{3,4}$')")
    url="#{Yahoo::HOST}#{query}#{Yahoo::OPTIONS}"

    begin
      yql_return=JSON.parse(Net::HTTP.get_response(URI.parse(url)).body, symbolize_names: true)
    rescue
      print "Connection error."
    end

    # Get what were after in a format for the Database
    p yql_return
    p url
    yql_return[:query][:results][:cashflow].each do |ticker| #For each ticker
      if ticker[:statement] # if there is a statment
        ticker[:statement].each do |period|
          columns = [:industry_id, :symbol]
          values = [ id, ticker[:symbol] ]
          period.each do |key, value|
            columns << key
            if value.is_a?(Hash) # If the hash's value is itself a hash
              values << value[:content].to_i # get the :content key value and convert to an int. All :content's are Integers
            else
              values << value # otherwise just get the value
            end
          end
          db=Database.new
          unless db.write_company_cashflow( { columns: columns, values: values })
          puts 'error writing to the database'
          end
        end
      end
    end
    return true
  end

  def industry_company_balancesheet(id)
    query=URI.encode("SELECT * FROM yahoo.finance.balancesheet WHERE symbol IN (SELECT company.symbol FROM yahoo.finance.industry WHERE id = '#{id}' AND company.symbol MATCHES '^[A-Z]{3,4}$')")
    url="#{HOST}#{query}#{OPTIONS}"
    begin
      yql_return=JSON.parse(Net::HTTP.get_response(URI.parse(url)).body, symbolize_names: true)
    rescue
      print "Connection error."
    end

  # Get what were after in a format for the Database
    yql_return[:query][:results][:balancesheet].each do |ticker| #For each ticker
      if ticker[:statement] # if there is a statment
        ticker[:statement].each do |period|
          columns = [:industry_id, :symbol]
          values = [ id, ticker[:symbol] ]
          period.each do |key, value|
            columns << key
            if value.is_a?(Hash) # If the hash's value is itself a hash
              values << value[:content].to_i # get the :content key value and convert to an int. All :content's are Integers
            else
              values << value # otherwise just get the value
            end
          end
          db=Database.new
          if db.write_company_balancesheet({ columns: columns, values: values })
          else
            puts 'error'
          end
        end
      end
    end
    return true
  end

end
