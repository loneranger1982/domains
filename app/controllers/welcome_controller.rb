class WelcomeController < ApplicationController
  
  def home
    @domain=Domain.count
    @filtered=Domain.where('domains.haswebsite IS NOT NULL').count
    @websites=Domain.where('domains.haswebsite =?',true).count
  end
end