$LOAD_PATH << '.'
require 'paytureBase'
require 'directApi'

puts "Hello, Ruby!";

merch = Merchant.new('elena_Test', '789555', 'http://localhost:7085')

pInf = PayInfo.new('4111111111111112', '5698', 'RubyTest|elena_Test|OrderId000000000000000001', 'pety ruby', '05', '20', '123')

print pInf.plain

api = APIManager.new(merch)

ord = Payment.new('RubyTest|elena_Test|OrderId000000000000000004', '5698')


res = api.pay(ord, pInf, 'RubyTestKey', '', '')
puts res
puts "Here I am"