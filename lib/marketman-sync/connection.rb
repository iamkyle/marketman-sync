
module MarketmanSync
  class Connection
    require "addressable/uri"

    PATH = Rails.env.production? ? "https://api.marketman.com/v3/buyers" : "https://api.marketman.com/v3/buyers"

    def initialize(installation = nil)
      @CYCLE = 1
      @installation = installation
      if installation
        @org = installation.object if installation.object_type == "Org"
        @queue = "marketman::#{installation.id}"
        @apiKey = installation.public_key
        @apiPassword = installation.refresh_token
      end
    end

    def renew_token(installation)
      return if !installation

      initialize(installation) if (!@installation || (@installation.id != installation.id))

      res = self.getToken(@apiKey,@apiPassword)

      if (res["IsSuccess"])
        @installation.update(
          expires_at: Chronic.parse(res["ExpireDateUTC"]),
          token: res["Token"]
        )
        Delayed::Job.where(queue: "#{@queue}::renew_token").destroy_all
        self.delay(run_at: @installation.expires_at, queue: "#{@queue}::renew_token").renew_token(installation)
        res
      else
        {errors: [{status: "403", title: "Unable to connect", detail: "Unable to connect to MarketMan - #{res[:ErrorMessage]}"}]}
      end
    end

    def exchange(params)
      
      token = self.getToken(params[:api_key],params[:api_password])

      if (token["IsSuccess"])
        {
          identifier: "marketman",
          domain: "marketman",
          token: token["Token"],
          public_key: params[:api_key],
          refresh_token: params[:api_password],
          expires_at: Chronic.parse(token["ExpireDateUTC"])
        }
      else
        token
      end
    end

    def getToken(api_key,api_password)
      url = URI("#{PATH}/auth/GetToken")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(url)
      request['content-type'] = 'application/json'
      request.body = {
        'APIKey': api_key,
        'APIPassword': api_password
      }.to_json

      response = http.request(request)

      return JSON.parse response.read_body
    end

  end
  
end