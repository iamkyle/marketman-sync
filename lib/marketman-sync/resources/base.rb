module MarketmanSync
  class Base
    PATH = Rails.env.production? ? "https://api.marketman.com/v3/buyers" : "https://api.marketman.com/v3/buyers"

    class InvalidSessionError < StandardError; end

    def initialize(installation, session = nil)
      @installation = installation
      start_session
    end
    
    def request(action, data = false)
      url = URI("#{PATH}/#{action}")
  
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
  
      request = Net::HTTP::Post.new(url)

      request['content-type'] = 'application/json'
      request['AUTH_TOKEN'] = "#{@session[:token]}"
      request.body = data.to_json if data

      puts "REQUEST"
      puts request.to_yaml
  
      response = http.request(request)
  
      res = JSON.parse response.read_body
    end
    private

    def start_session
      @session = {
        domain: @installation.domain,
        apiKey: @installation.public_key,
        apiPassword: @installation.refresh_token,
        token: @installation.token
      }
    end
  end
end