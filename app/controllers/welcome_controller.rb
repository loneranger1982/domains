class WelcomeController < ApplicationController
  
  def home
    @domain=Domain.count
    @filtered=""#Domain.where('"domains.hasWebsite" IS NOT NULL').count
    @websites=""#Domain.where('"domains.hasWebsite" =?',true).count
    @jobs=Sidekiq::Workers.new
  end
end