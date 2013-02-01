require 'rubygems'
require 'mechanize'
require 'open-uri'
require 'json'
require 'yaml'

class Cart

  def initialize
  end

  def add_product id_or_product
    product = id_or_product.is_a?(Product) ? id_or_product : Product.find(id_or_product)
    if product.in_stock?
      puts "Adding #{product.title}"
      puts "Price #{product.price}"
      agent.get("http://cart.dx.com/shoppingcart.dx/add.#{product.id}")
    else
      puts "Error adding #{product.title}, out of stock"
    end
  end

  def total
    agent.get("https://cart.dx.com/shoppingcart.dx")
    agent.page.parser.css('#ctl00_content_lblGrandTotal')[0].text
  end

  def checkout
    form = agent.page.form_with(:dom_id => "aspnetForm")
    button = form.button_with(:dom_id => "ctl00_content_lnkCreaditCardCheckOut")
    agent.submit(form, button)
    agent.page.forms[0].submit
  end

  def purchase
    resp = agent.post('https://cart.dx.com/CC/BillingInfo', billing_config)
  end

  def confirm
    agent.get("https://cart.dx.com/CC/Confirm")
    agent.page.forms[0].submit

    if agent.page.title != "Checkout by Credit Card Completed"
      puts "Checkout by Credit Card Completed"
    else
      puts "Checkout Failed, debug below"
      puts agent.page.inspect
    end
  end

  def address
    agent.get("https://cart.dx.com/CC/ShippingInfo")
    cartid = agent.page.parser.css('#cartId')[0]['value']
    agent.post('https://cart.dx.com/Account/AnonymousRegister', {"email" => config["billing"]["email"]})
    resp = agent.post('https://cart.dx.com/CC/CalShippingFee', shipping_config.merge({"cartId" => cartid }))

    results =  JSON.parse(resp.body)
    puts "Final total #{results["grandTotal"]}"
    # {"success":true,"currencyCode":"USD","currencySymbol":"$","subTotal":2.1,"shippingFee":0,"discountTotal":0,"handlingFee":0,"packingFee":0,"grandTotal":2.1}

    agent.post('https://cart.dx.com/CC/ShippingInfo', shipping_config)
    agent.get("https://cart.dx.com/CC/BillingInfo")
  end

  def pay
    self.checkout
    self.address
    self.purchase
    self.confirm
  end

  def config 
    @config ||= YAML.load(File.read("config.yml"))
  end

  def billing_config
    config["billing"].merge(config["card"])
  end

  def shipping_config
    config["shipping"].merge({"shippingMethod" => "0"})
  end

  def agent
    @agent ||= agent = Mechanize.new
  end
end