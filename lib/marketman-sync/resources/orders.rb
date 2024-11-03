module MarketmanSync
  class Orders < Base

    class << self

      def getOrdersByDeliveryDate(installation = nil, params = {})
        params.deep_transform_keys! { |key| key.camelize() }
        params["DateTimeFromUTC"] = (Time.now - 1.week).strftime("%Y/%m/%d %H:%M:%S") if (!params.try(:DateTimeFromUTC))
        params["DateTimeToUTC"] = (Time.now + 1.day).strftime("%Y/%m/%d %H:%M:%S") if (!params.try(:DateTimeToUTC))
        session = new(installation) if installation
        puts params
        response = session.request("orders/GetOrdersByDeliveryDate",params)
      end 

    end

    private

  end
end
