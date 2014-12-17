class WinesController < ApplicationController

  require 'httparty'
  require 'uri'
  require 'oj'

  def index
    @wines = Wine.all

    highestScore = Wine.maximum("my_score")
    @highestWine = Wine.where(my_score: highestScore).first

    # @reds = Wine.where(varietal: list of red wines is malbec.....)


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
        # now we have converted snooth if it exists
        # now, if bm score exists, add them together otherwise, double snooth
        if wine.bm_score != nil
          wine.my_score = convertSnooth + wine.bm_score
          puts "ADD SNOOTH CONVERT + BM SCORE"
          puts convertSnooth + wine.bm_score
        else
          puts "NO BM SCORE SO DOUBLE THE SNOOTH SCORE"
          puts convertSnooth * 2
          wine.my_score = convertSnooth * 2
        end
      else
        puts "THERE ARE NO SCORES AVAILABLE FROM SNOOTH OR FROM BEVMO"
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
