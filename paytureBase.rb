require 'net/http'

module Commands
    PAY = 'Pay'
    BLOCK = 'Block'
    CHARGE = 'Charge'
    REFUND = 'Refund'
    UNBLOCK = 'Refund'
    PAYSTATUS = 'PayStatus'
    GETSTATE = 'GetState'
    INIT = 'Init'
    REGISTER = 'Register'
    CHECK = 'Check'
    DELETE = 'Delete'
    REMOVE = 'Remove'
    UPDATE = 'Update'
    ADD = 'Add'
    ACTIVATE = 'Activate'
    GETLIST = 'GetList'
    SENDCODE = 'SendCode'
    PAY3DS = 'Pay3DS'
    BLOCK3DS = 'Block3DS'
    PAYSUBMIT3DS = 'PaySubmit3DS'
    MPPAY = 'MPPay'
    MPBLOCK = 'MPBlock'
    ANDPAY = 'AndroidPay'
    APPLEPAY = 'ApplePay'
end


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
include Commands
    attr_reader :merchant
    attr_reader :reqUrl
    attr_reader :api
    def initialize(merch, api)
        @merchant = merch
        @reqUrl = merch.host + '/' + api
        @api = api
    end

    def requestToPayture(parms, apiMethod)
        uri = URI(@reqUrl + '/' + apiMethod)
        req = Net::HTTP::Post.new(uri)
        req.set_form_data(parms)
        
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
        prms = Hash[key => @merchant.name, 'OrderId' => payment.orderId]
        if @api == 'vwapi' || @api == 'apim'
            prms = prms.merge({
                'Password' => @merchant.password,
                'Amount' => payment.amount
            })
        end
        return requestToPayture(prms, Commands::CHARGE)
    end

    def unblock(payment)
        key = 'Key'
        if @api == 'vwapi'
            key = 'VWID'
        end
        prms = Hash[key => @merchant.name, 'OrderId' => payment.orderId, 'Amount' => payment.amount]
        if @api == 'vwapi' || @api == 'apim'
            prms['Amount'] = payment.amount
        end
        return requestToPayture(prms, Commands::UNBLOCK)
    end

    def refund(payment)
        prms = Hash.new
        if @api == 'vwapi'
            prms = prms.merge({'VWID' => @merchant.name, 
            'DATA' => "OrderId=#{payment.orderId};Password=#{@merchant.password};Amount=#{payment.amount}"
            })
        else
            prms = prms.merge({
                'Key' => @merchant.name,
                'OrderId' => payment.orderId,
                'Amount' => payment.amount,
                'Password' => @merchant.password
            })
        end
        return requestToPayture(prms, Commands::REFUND)
    end

    def payStatus(payment)
        prms = Hash.new
        if @api == 'vwapi'
            prms = prms.merge({'VWID' => @merchant.name, 'DATA' => "OrderId=#{payment.orderId}" })
        else
            prms = prms.merge({'Key' => @merchant.name, 'OrderId' => payment.orderId })
        end
        return requestToPayture(prms, Commands::PAYSTATUS)
    end

    def getState(payment)
        prms = Hash['Key' => @merchant.name, 'OrderId' => payment.orderId]
        return requestToPayture(prms, Commands::GETSTATE)
    end
end
