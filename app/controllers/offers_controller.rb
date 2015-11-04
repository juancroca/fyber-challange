class OffersController < ApplicationController

  def index
    client ||= Fyber::Client.new(FYBER['api_key'])
    respond_to do |format|
      format.html
      format.js do
        offer_params = params[:offer].select{|key, value| !value.empty?}.merge(FYBER['params'])
        if @offers = client.get_offers(offer_params)
          render 'offers'
        else
          render 'errors'
        end
      end
    end
  end
end
