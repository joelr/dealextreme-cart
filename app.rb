require './cart'

cart = Cart.new 
# $1.80 mario mushroom
cart.add_product 27734
puts cart.total

#uncomment to purchase, this is a live transaction if you card details are set!
#cart.pay