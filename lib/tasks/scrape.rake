namespace :scrape do
  desc "TODO"
  task bm: :environment do

  require 'rubygems'
  require 'mechanize'
  agent = Mechanize.new


  wine_links = [
    "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Albarino/_/N-13Z1z13uxb",
    "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Barbaresco/_/N-13Z1z141c7",
    "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Barbera/_/N-13Z1z14138",
    "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Barolo/_/N-13Z1z141c5"
    # "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Bordeaux/_/N-13Z1z141hm",
    # "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Brunello-di-Montalcino/_/N-13Z1z141eh",
    # "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Cabernet-Sauvignon/_/N-13Z1z141x7",
    # "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Champagne-Sparkling/_/N-13Z1z141wk",
    # "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Chardonnay/_/N-13Z1z141u0",
    # "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Chenin-Blanc/_/N-13Z1z140ee",
    # "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Chianti/_/N-13Z1z141rs/No-",
    # "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Fortified-Dessert/_/N-13Z1z141xp",
    # "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Gewurztraminer/_/N-13Z1z1416f",
    # "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Grenache/_/N-13Z1z13zou",
    # "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Malbec/_/N-13Z1z141a5",
    # "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Merlot/_/N-13Z1z141tp",
    # "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Moscato/_/N-13Z1z138pr",
    # "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Muscat/_/N-13Z1z141o8",
    # "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Nero-d-Avola/_/N-13Z1z13t1d",
    # "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Petite-Sirah/_/N-13Z1z140wm",
    # "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Pinot-Blanc/_/N-13Z1z13g5o",
    # "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Pinot-Grigio-Pinot-Gris/_/N-13Z1z141tu",
    # "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Pinot-Noir/_/N-13Z1z141w8",
    # "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Port/_/N-13Z1z13s4u",
    # "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Rhone/_/N-13Z1z141fx",
    # "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Riesling/_/N-13Z1z141sr",
    # "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Rioja/_/N-13Z1z140u6",
    # "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Rose-Blush/_/N-13Z1z141rb",
    # "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Sauvignon-Blanc/_/N-13Z1z141vt",
    # "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Syrah-Shiraz/_/N-13Z1z141pg",
    # "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Tempranillo/_/N-13Z1z141ik",
    # "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Torrontes/_/N-13Z1z13sfn",
    # "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Viognier/_/N-13Z1z141ir",
    # "http://www.bevmo.com/Shop/ProductList.aspx/Wine/Zinfandel/_/N-13Z1z141pp"
  ]


  wine_links.each do |wine_link|

    (0..300).step(10) do |num|
      wine_link_page = wine_link + "/No-" + num.to_s
      page = agent.get(wine_link_page)

      page.links_with(:class => 'ProductListItemLink').each do |link|
        page = link.click
        wine = Wine.new
        wine.title = page.search('h1').text.strip
        wine.price = page.search('.ProductDetailItemPrice').text.strip
        wine.price_sale = page.search('.ProductDetailItemPrice_ClubBev').text.strip
        wine.company = page.search('.uxTableProductInfo tr:first-child td a').text.strip
        wine.vintage = page.search('.uxTableProductInfo tr:nth-child(2) td a').text.strip
        wine.varietal = page.search('.uxTableProductInfo tr:nth-child(3) td a').text.strip
        wine.country = page.search('.uxTableProductInfo tr:nth-child(4) td a').text.strip
        wine.region = page.search('.uxTableProductInfo tr:nth-child(5) td a').text.strip
        wine.description = page.search('.ProductDetailCell p').text.strip
        wine.sku = page.search('p.uxGrey').text.strip

        images = page.search(".ProductDetailCell img")
        image_string = agent.get(images.first.attributes["src"]).save
        wine.image = image_string.chop.chop

        wine.save
      end
    end
  end

  # page.search('.ProductListItemLink').each do |wine|
  #   puts wine
  # end



  end

end

