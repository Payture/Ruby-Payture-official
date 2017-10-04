
class EWalletManager
    def initialize(merch)
        #need include the OrderManager
        @ordManager = OrderManager.new(merch, 'vwapi')
    end

    def init()
    end

end