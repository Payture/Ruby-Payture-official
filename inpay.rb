class InpayManager < OrderManager
    def initialize(merch)
        super(merch, 'apim')
    end

    def init(order, session, tag, lang, ip, retUrl, custFields)
        prms = Hash['Key' => @merchant.name, 'Data' => "SessionType=#{session};Language=#{lang};IP=#{ip};TemplateTag=#{tag};Url=#{retUrl}"]    #apply customer fields
        return requestToPayture(prms, Commands::INIT)
    end
end
