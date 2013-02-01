class RandomProduct < Product
  
  def self.find options = {}
    agent ||= Mechanize.new
    options[:price_from] ||= 0
    options[:price_to] ||= 5
    agent.get("http://dx.com/c/sports-outdoors-1699/cycling-1607?page=1&pageSize=500&priceFrom=#{options[:price_from]}&priceTo=#{options[:price_to]}")
    prods = agent.page.parser.css('.productList a').map{|l| l['href']}.select{|l| l.include?("/p/")}
    sku = prods.shuffle.first.split("/p/").last.split("-").last
    Product.find(sku)
  end

end