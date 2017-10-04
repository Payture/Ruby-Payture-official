class InpayManager
    def initialize(merch)
        #need include the OrderManager
        @ordManager = OrderManager.new(merch, 'apim')
    end

    def init(order, session, tag, lang, ip, retUrl, custFields)
        prms = ['Key' => @ordManager.service.merchant.name, 'Data' => "SessionType=#{session};Language=#{lang};IP=#{ip};TemplateTag=#{tag};Url=#{retUrl}"]    #apply customer fields
        #sent request and get response
    end
end
