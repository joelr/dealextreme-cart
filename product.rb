require 'rubygems'
require 'mechanize'
require 'open-uri'
require 'json'
require 'yaml'

class Product
  
  def initialize id
    @id = id
  end
  
  def self.find id
    new(id).find
  end

  def id
    @id
  end

  def find
    agent.get("http://dx.com/p/#{@id}")
    self
  end
  
  def price
    @price ||= agent.page.parser.css('#price')[0].text.to_f
  end

  def title
    @title ||= agent.page.parser.css('#headline')[0].text
  end
  
  def image_count
    @image_count ||= agent.page.parser.css('#product-small-images li').size
  end
  
  def large_images
    
  end

  def agent
    @agent ||= Mechanize.new
  end
  
  def rating
    @rating ||=  agent.page.parser.css('.review_rate .starts span')[0].text.to_i
  end
  
  def reviews
    @reviews ||=  agent.page.parser.css('.review_rate .tu')[0].text.split(" ").first.to_i
  end
  
  def in_stock?
    @instock ||= !agent.page.parser.css('body').text.include?("Item is temporarily sold out.")
  end
end

# 
# #p = Product.find 34423
# p = Product.find 109654
# #p = Product.find 8627
# puts p.title
# puts p.rating
# puts p.reviews
# puts p.price.inspect
# 
# puts p.instock?.inspect