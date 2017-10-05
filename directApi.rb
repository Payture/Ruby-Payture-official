class PayInfo
    def initialize(pan, amnt, ordId, crdHolder, exMonth, exYear, sCode)
        @pan, @amount, @orderId, @cardHolder, @eMonth, @eYear, @secureCode = pan, amnt, ordId, crdHolder, exMonth, exYear, sCode
    end
    def plain
        return "OrderId=#{@orderId};Amount=#{@amount};CardHolder=#{@cardHolder};PAN=#{@pan};EMonth=#{@eMonth};EYear=#{@eYear};SecureCode=#{@secureCode};"
    end
end

class APITransaction 
    def initialize(key, pInfo, order, custKey, paytureId, custFields)
        @key, @payInfo, @payment, @customerKey, @paytureId, @customerFields = key, pInfo, order, custKey, paytureId, custFields
    end
end

class APIManager < OrderManager
    def initialize(merch)
        super(merch, 'api')
    end

    def pay(order, pInfo, custKey, custParams, paytureId)
        prms = Hash['Key' => @merchant.name, 'Amount' => order.amount, 'OrderId' => order.orderId,
        'CustomerKey' => 'RubyTestCustomer', 'PayInfo' => pInfo.plain, 'PaytureId' => '' ]
        return requestToPayture(prms, Commands::PAY)
    end

    def block(order, pInfo, custKey, custParams, paytureId)
        prms = Hash['Key' => @merchant.name, 'Amount' => order.amount, 'OrderId' => order.orderId,
        'CustomerKey' => 'RubyTestCustomer', 'PayInfo' => pInfo.plain, 'PaytureId' => '' ]
        return requestToPayture(prms, Commands::BLOCK)
    end
end

