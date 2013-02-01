require './cart'
require './product'
require './random_product'

cart = Cart.new 
cart.add_product 71927
cart.add_product RandomProduct.find
puts cart.total

#cart.pay