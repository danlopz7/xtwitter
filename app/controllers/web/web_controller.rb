class Web::WebController < ApplicationController

    before_action :set_default_format


    private 
    
    def set_default_format
        request.format = :html unless params[:format]
      end
end