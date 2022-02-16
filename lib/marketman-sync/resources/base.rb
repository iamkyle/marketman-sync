module MarketmanSync
  class Base < ActiveResource::Base
    
    class InvalidSessionError < StandardError; end

    def initialize(installation, session = nil)
      @CYCLE = 1

      @installation = installation
  
      unless @session && @session.domain == @installation.domain
        start_session if @installation
      end
    end
    
    class << self
      
    end

    def persisted?
      !id.nil?
    end

    private

    def start_session
     
    end

  end
end