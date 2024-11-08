module MarketmanSync
  class Inventory < Base

    class << self

      def getItems(installation = nil, params = {})
        params.deep_transform_keys! { |key| key.camelize() }
        session = new(installation) if installation
        response = session.request("inventory/GetItems",params)
      end
      def getPreps(installation = nil, params = {})
        params.deep_transform_keys! { |key| key.camelize() }
        session = new(installation) if installation
        response = session.request("inventory/GetPreps",params)
      end

      def getInventoryItems(installation = nil, params = {})
        params.deep_transform_keys! { |key| key.camelize() }
        session = new(installation) if installation
        newParams = {}
        newParams["BuyerGuid"] = params["BuyerGuid"]
        newParams["buffer"] = "buffer"
        puts newParams
        response = session.request("inventory/GetInventoryItems",newParams)
      end

      def getInventoryCounts(installation = nil, params = {})
        params.deep_transform_keys! { |key| key.camelize() }
        session = new(installation) if installation
        response = session.request("inventory/GetInventoryCounts",params)
      end

      def setInventoryItemParLevels(installation = nil, params = {})
        params.deep_transform_keys! { |key| key.camelize() }
        session = new(installation) if installation
        response = session.request("sales/SetInventoryItemParLevel",params)
      end
      

      def setInventoryItemParLevel(installation = nil, par_level = nil, data = nil)
        
        session = new(installation) if installation
        
        data = {
          BuyerGuid: par_level.remote_guid,
          InventoryItemID: par_level.remote_id.to_i,
          ItemParLevel: par_level.current_value
        } if par_level

        res = session.request("sales/SetInventoryItemParLevel",data)
      
        {is_success: res["IsSuccess"], error_message: res["ErrorMessage"], error_code: res["ErrorCode"]}
      end

      def DeleteMenuItem(installation = nil, data = {})
        session = new(installation) if installation
        response = session.request("inventory/DeleteMenuItem",params)
      end


    end


    private

  end
end
