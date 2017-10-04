require 'net/http'

class Merchant
    attr_accessor :name
    attr_accessor :password
    attr_accessor :host
    def initialize(name, pass, host)
        @name, @password, @host = name, pass, host
    end
end

class Payment
    attr_accessor :orderId
    attr_accessor :amount
    def initialize(ordId, amnt)
        @orderId =  ordId
        @amount = amnt
    end
end

class  Service
    attr_reader :merchant
    attr_reader :reqUrl
    attr_reader :api
    def initialize(merch, api)
        @merchant = merch
        @reqUrl = merch.host + '/' + api
        @api = 'api'
    end
    #funcs for send http are needed 
    def requestToPayture(parms, apiMethod)
=begin
        uri = URI(@reqUrl + '/' + apiMethod)
        res = Net::HTTP.post_form(uri, parms)
=end

        uri = URI(@reqUrl + '/' + apiMethod)
        req = Net::HTTP::Post.new(uri)
        hashel = parms[0]
        req.set_form_data(hashel)
        
        res = Net::HTTP.start(uri.hostname, uri.port) do |http|
          http.request(req)
        end
        
        case res
        when Net::HTTPSuccess, Net::HTTPRedirection
            return res.body
        else
            return res.value
        end
    end
end

class OrderManager < Service
    def charge(payment)
        key = 'Key'
        if @api == 'vwapi'
            key = 'VWID'
        end
        prms = [key => @merchant.name, 'OrderId' => payment.orderId]
        if @api == 'vwapi' || @api == 'apim'
            prms['Password'] = @merchant.password
            prms['Amount'] = payment.amount
        end
        return requestToPayture(prms, 'Charge')
    end

    def unblock(payment)
        key = 'Key'
        if @api == 'vwapi'
            key = 'VWID'
        end
        prms = [key => @merchant.name, 'OrderId' => payment.orderId, 'Amount' => payment.amount]
        if @api == 'vwapi' || @api == 'apim'
            prms['Amount'] = payment.amount
        end
        return requestToPayture(prms, 'Unblock')
    end

    def refund(payment)
        prms = Hash.new
        if @api == 'vwapi'
            prms['VWID'] = @merchant.name
            prms['DATA'] = "OrderId=#{payment.orderId};Password=#{@merchant.password};Amount=#{payment.amount}"
        else
            prms['Key'] = @merchant.name
            prms['OrderId'] = payment.orderId
            prms['Amount'] = payment.amount
            prms['Password'] = @merchant.password
        end
        return requestToPayture(prms, 'Refund')
    end

    def payStatus(payment)
        prms = Hash.new
        if @api == 'vwapi'
            prms['VWID'] = @merchant.name
            prms['DATA'] = "OrderId=#{payment.orderId}"    
        else
            prms['Key'] = @merchant.name
            prms['OrderId'] = payment.orderId
        end
        return requestToPayture(prms, 'PayStatus')
    end

    def getState(payment)
        prms = ['Key' => @merchant.name, 'OrderId' => payment.orderId]
        return requestToPayture(prms, 'GetState')
    end
end
