class Database

  DATABASE="#{USShares::DATA_DIR}/us_shares.sqlite3"

  def initalize ()

  end

  def build
    db=SQLite3::Database.new(DATABASE)

#Tables and Views

sql = <<SQL
    CREATE TABLE IF NOT EXISTS industry(id INTEGER PRIMARY KEY ASC, name TEXT, rank INTEGER);
    CREATE TABLE IF NOT EXISTS industry_ticker(id INTEGER PRIMARY KEY ASC, ind_id INTEGER, ticker TEXT, name TEXT);
SQL

sql_BalanceSheet = <<SQL
CREATE TABLE Company_BalanceSheet (
  id integer PRIMARY KEY NOT NULL,
  industry_id integer(128),
  symbol char(10),
  period char(50),
  CashAndCashEquivalents integer(128),
  ShortTermInvestments integer(128),
  NetReceivables integer(128),
  Inventory integer(128),
  OtherCurrentAssets integer(128),
  TotalCurrentAssets integer(128),
  LongTermInvestments integer(128),
  PropertyPlantandEquipment integer(128),
  Goodwill integer(128),
  IntangibleAssets integer(128),
  AccumulatedAmortization integer(128),
  OtherAssets integer(128),
  DeferredLongTermAssetCharges integer(128),
  TotalAssets integer(128),
  AccountsPayable integer(128),
  Short_CurrentLongTermDebt integer(128),
  OtherCurrentLiabilities integer(128),
  TotalCurrentLiabilities integer(128),
  LongTermDebt integer(128),
  OtherLiabilities integer(128),
  DeferredLongTermLiabilityCharges integer(128),
  MinorityInterest integer(128),
  NegativeGoodwill integer(128),
  TotalLiabilities integer(128),
  MiscStocksOptionsWarrants integer(128),
  RedeemablePreferredStock integer(128),
  PreferredStock integer(128),
  CommonStock integer(128),
  RetainedEarnings integer(128),
  TreasuryStock integer(128),
  CapitalSurplus integer(128),
  OtherStockholderEquity integer(128),
  TotalStockholderEquity integer(128),
  NetTangibleAssets integer(128)
);
SQL

sql_CashFlow = <<SQL
CREATE TABLE Company_Cashflow (
  id integer PRIMARY KEY NOT NULL,
  industry_id integer(128),
  symbol char(5),
  period text(50),
  NetIncome integer(128),
  Depreciation integer(128),
  AdjustmentsToNetIncome integer(128),
  ChangesInAccountsReceivables integer(128),
  ChangesInLiabilities integer(128),
  ChangesInInventories integer(128),
  ChangesInOtherOperatingActivities integer(128),
  TotalCashFlowFromOperatingActivities integer(128),
  CapitalExpenditures integer(128),
  Investments integer(128),
  OtherCashflowsfromInvestingActivities integer(128),
  TotalCashFlowsFromInvestingActivities integer(128),
  DividendsPaid integer(128),
  SalePurchaseofStock integer(128),
  NetBorrowings integer(128),
  OtherCashFlowsfromFinancingActivities integer(128),
  TotalCashFlowsFromFinancingActivities integer(128),
  EffectOfExchangeRateChanges integer(128),
  ChangeInCashandCashEquivalents integer(128)
);
SQL

sql_Industry_meta = <<SQL
CREATE TABLE industry_meta (
  ind_id integer PRIMARY KEY NOT NULL,
  rank integer
);
SQL

 sql_views1 =<<SQL
  CREATE VIEW industry_rank AS
  SELECT industry.id, industry.name, industry_meta.rank from industry
  JOIN industry_meta ON industry.id=industry_meta.ind_id
SQL

 sql_views2 =<<SQL
  CREATE VIEW known_ind AS
  SELECT industry.id, industry.name, industry_meta.rank from industry
  JOIN industry_meta ON industry.id=industry_meta.ind_id
  WHERE industry_meta.rank <= 2
SQL

sql_view3 =<<SQL
  CREATE VIEW unique_ticker AS
  SELECT ind_id, ticker, name
  FROM industry_ticker
  WHERE length(ticker) <= 4
SQL

db.execute_batch(sql)


  end

  def write_company_cashflow (params)
    begin
      @db=SQLite3::Database.new(DATABASE)
      @db.results_as_hash = true

      place_holders=[ ]
      params[:values].count.times { place_holders << '?' }
      @db.execute("INSERT INTO Company_Cashflow ( #{ params[:columns].join(', ') } ) VALUES ( #{ place_holders.join(', ') } )", params[:values])
      true

    rescue SQLite3::Exception => e
      print "Exception occurred: "
      puts e
      false

    ensure
      @db.close if @db
    end
  end

  def write_company_balancesheet(params)
    begin
      @db=SQLite3::Database.new(DATABASE)
      @db.results_as_hash = true

      place_holders=[ ]
      params[:values].count.times { place_holders << '?' }
      @db.execute("INSERT INTO Company_BalanceSheet ( #{ params[:columns].join(', ') } ) VALUES ( #{ place_holders.join(', ') } )", params[:values])
      true

    rescue SQLite3::Exception => e
      print "Exception occurred: "
      puts e
      false

    ensure
      @db.close if @db
    end
  end

  def clear_table(table)
    db=SQLite3::Database.new(DATABASE)
    db.execute("DELETE FROM #{table}")
    db.close
  end

  def write_industry(industry)
    db=SQLite3::Database.new(DATABASE)
      sql=db.prepare("INSERT or REPLACE INTO industry (id, name) VALUES (#{ industry[:id] }, \"#{ industry[:name] }\" );")
      sql.execute
  end

  def write_industry_tickers(ind_id, ticker, name)
    db=SQLite3::Database.new(DATABASE)
      sql=db.prepare("INSERT or REPLACE INTO industry_ticker (ind_id, ticker, name) VALUES (?, ?, ?);")
      sql.bind_params(ind_id, ticker, name)
      sql.execute()
  end

end
