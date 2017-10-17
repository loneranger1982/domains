class WelcomeController < ApplicationController
  
  def home
    @domain=Domain.count
    @filtered=Domain.where('haswebsite IS NOT NULL').count
    @websites=Domain.where('haswebsite =?',true).count
  end
end