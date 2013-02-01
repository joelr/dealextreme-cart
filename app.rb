require './cart'
require './product'

cart = Cart.new 
cart.add_product 71927
cart.add_product 27734
cart.add_product 34423
cart.add_product 109654
cart.add_product 8627
cart.pay
puts cart.total

#uncomment to purchase, this is a live transaction if you card details are set!
#cart.pay