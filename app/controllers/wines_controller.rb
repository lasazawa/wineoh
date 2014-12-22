class WinesController < ApplicationController

  require 'httparty'
  require 'uri'
  require 'oj'

  def index
    @allWines = Wine.all

    @winesWithScore = @allWines.where.not('my_score' => nil)
    @wines = @winesWithScore.order("my_score DESC")

    highestScore = Wine.maximum("my_score")
    @highestWine = Wine.where(my_score: highestScore).first

    highestValue = Wine.maximum("value_score")
    @valueWine = Wine.where(value_score: highestValue).first

    @uniques = @wines.where(varietal: "Petite Sirah")
    highScore = @uniques.maximum("my_score")
    @theUnique = @uniques.where(my_score: highScore).first

    @allVarietals = @allWines.uniq.pluck(:varietal)

  end

  def reds
    @reds = Wine.where(color: "red")

    highest = @reds.maximum("my_score")
    @highestRed = @reds.where(my_score: highest).first

    highestValue = @reds.maximum("value_score")
    @valueRed = @reds.where(value_score: highestValue).first

    @uniqueR = @reds.where(varietal: "Brunello di Montalcino")
    highScore = @uniqueR.maximum("my_score")
    @uniqueRed = @uniqueR.where(my_score: highScore).first

    @redVarietals = @reds.uniq.pluck(:varietal)
  end


  def whites
    @whites = Wine.where(color: "white")

    highest = @whites.maximum("my_score")
    @highestWhite = @whites.where(my_score: highest).first

    highestValue = @whites.maximum("value_score")
    @valueWhite = @whites.where(value_score: highestValue).first

    @uniqueW = @whites.where(varietal: "Torrontes")
    highScore = @uniqueW.maximum("my_score")
    @uniqueWhite = @uniqueW.where(my_score: highScore).first

    @whiteVarietals = @whites.uniq.pluck(:varietal)
  end


  def roses
    @roses = Wine.where(color: "rose")

    highest = @roses.maximum("my_score")
    @highestRose = @roses.where(my_score: highest).first

    highestValue = @roses.maximum("value_score")
    @valueRose = @roses.where(value_score: highestValue).first
  end

  def filter
    wineColor = params[:wineColor]
    wines = Wine.where(color: wineColor)
    render json: wines
  end



  def show
    @wine = Wine.find(params[:id])

    @varietal = @wine.varietal

    @allVarietals = Wine.where(varietal: @varietal)
    @allVarietalsWithScore = @allVarietals.where.not('my_score' => nil)
    @varietal_rec = @allVarietalsWithScore.order("my_score DESC").limit(5)

    # Deal.find(:all, :order => 'quantity_purchased * price', :limit => 100);
    # Deal.order('quantity_purchased * price').limit(100)
  end

  def slot

  end

  # get snooth rating
  def snooth

    @wines = Wine.all

    @wines.each do |wine|

      puts wine.company

      uri = URI.escape("http://api.snooth.com/wines/?akey=8xo0yzmftoede3eczasvyrkedfs9hothrmaw1w69hohrtl12&q=#{wine.company} #{wine.vintage} #{wine.varietal}")

      response = HTTParty.get uri
      object = JSON.parse response

      puts wine.company
      puts wine.vintage
      puts wine.varietal

      if object['wines'] != nil
        # if theres a wine[0]
        if object['wines'][0]['snoothrank'] != "n/a" || object['wines'][0]['snoothrank'] != nil
          puts object['wines'][0]['snoothrank']
          snooth_score = object['wines'][0]['snoothrank'].to_f
          if snooth_score == 0
            wine.snooth_rating == nil
          else
            wine.snooth_rating = snooth_score
          end
        end
      end
      wine.save
    end
  end

  # combine score of critic with snooth to get "my_score"
  def score
    @wines = Wine.all
    @wines.each do |wine|

      if wine.snooth_rating != nil
        puts wine.snooth_rating.to_f
        convertSnooth = ((wine.snooth_rating.to_f * 14) + 40)
        puts convertSnooth
        # if snooth score is found, convert it
        # now, if bm score exists, add them together otherwise, double snooth
        if wine.bm_score != nil
          puts "ADD SNOOTH CONVERT + BM SCORE"
          puts convertSnooth + wine.bm_score
          wine.my_score = convertSnooth + wine.bm_score
        else
          puts "NO BM SCORE SO DOUBLE THE SNOOTH SCORE"
          puts convertSnooth * 2
          wine.my_score = convertSnooth * 2
        end
      else
        puts "THERE ARE NO SCORES AVAILABLE FROM SNOOTH OR FROM BEVMO"
      end

      if wine.price_sale != ""
        lowerPrice = wine.price_sale
        lowerPrice[0] = ""
        puts lowerPrice.to_f
        if wine.my_score != nil
          puts "whats this"
          value = wine.my_score.to_f / lowerPrice.to_f
          puts "VALUE"
          puts value
          wine.value_score = value
          puts wine.value_score.to_f
        end
      else
        lowerPrice = wine.price
        lowerPrice[0] = ""
        puts lowerPrice.to_f
        if wine.my_score != nil
          puts "whats this2"
          value = wine.my_score.to_f / lowerPrice.to_f
          puts "VALUE"
          puts value
          wine.value_score = value
          puts wine.value_score.to_f
        end
      end

      wine.save
    end
  end

end
