class WelcomeController < ApplicationController
require 'sidekiq/api'
  def home
    @domain=Domain.count
    @filtered=Domain.where.not(hasWebsite: nil).count
    @websites=Domain.where(hasWebsite: true).count
    @jobs=Sidekiq::Workers.new
  end
end