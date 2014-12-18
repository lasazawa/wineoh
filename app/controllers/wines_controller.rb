class WinesController < ApplicationController

  require 'httparty'
  require 'uri'
  require 'oj'

  def index
    @wines = Wine.all

    highestScore = Wine.maximum("my_score")
    @highestWine = Wine.where(my_score: highestScore).first

    highestValue = Wine.maximum("value_score")
    @valueWine = Wine.where(value_score: highestValue).first

  end

  def reds
    @reds = Wine.where(color: "red")

    highest = @reds.maximum("my_score")
    @highestRed = @reds.where(my_score: highest).first

    highestValue = @reds.maximum("value_score")
    @valueRed = @reds.where(value_score: highestValue).first

  end


  def whites
    @whites = Wine.where(color: "white")

    highest = @whites.maximum("my_score")
    @highestWhite = @whites.where(my_score: highest).first

    highestValue = @whites.maximum("value_score")
    @valueWhite = @whites.where(value_score: highestValue).first
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
    @varietal_rec = Wine.where(:varietal => @varietal)

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

  def value
        @highestValue = nil
    @wines = Wine.all
    @wines.each do |w|
      if w.my_score != nil
        if w.price_sale != nil
          lowerPrice = w.price_sale
        else
          lowerPrice = w.price
        #   wPrice = w.price_sale
        # else
        #   wPrice = w.price
        # end
        # # remove "$" from wPrice and turn in to float
        # wPrice[0] = ""
        # thePrice = wPrice.to_f
        # puts thePrice

        # value = w.my_score / thePrice
        # puts value

        # if value > @highestValue
        #   @highestValue = value
        # end
        end
        puts lowerPrice
      end
    end
  end

end
