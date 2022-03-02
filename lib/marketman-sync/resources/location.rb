module MarketmanSync
  class Location < Base

    class << self
      
      def all(installation = nil, params = {})
        session = new(installation) if installation && !@session
        response = session.request("partnerAccounts/GetAuthorisedAccounts")
        locations = []
        if response["IsSuccess"]
          response["Chains"] && response["Chains"].each do |chain|
            locations << {
              id: chain["Guid"],
              name: chain["ChainName"],
              type: "chain"
            }
            chain["Buyers"] && chain["Buyers"].each do |buyer| 
              locations << {
                id: buyer["Guid"],
                name: buyer["BuyerName"],
                type: "buyer"
              }
            end
            chain["Vendors"] && chain["Vendors"].each do |buyer| 
              locations << {
                id: buyer["Guid"],
                name: buyer["VendorName"],
                type: "vendor"
              }
            end
          end
          response["Buyers"] && response["Buyers"].each do |buyer| 
            locations << {
              id: buyer["Guid"],
              name: buyer["BuyerName"],
              type: "buyer"
            }
          end
          response["Vendors"] && response["Vendors"].each do |buyer| 
            locations << {
              id: buyer["Guid"],
              name: buyer["VendorName"],
              type: "vendor"
            }
          end
        else 
        end
        return locations
      end

      def find(id)

      end
    end


    private

  end
end
