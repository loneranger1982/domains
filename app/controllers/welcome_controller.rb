class WelcomeController < ApplicationController
require 'sidekiq/api'
  def home
    @domain=Domain.count
    @filtered=Domain.where.not(haswebsite: nil).count
    @websites=Domain.where(haswebsite: true).count
    @expired=Domain.where("auctionendtime < ?",Time.now.to_i).count
    @jobs=Sidekiq::Workers.new
    @queue=Sidekiq::Queue.new
  end
  
  def canceljob
    Sidekiq::Status.cancel params[:id]
    job=Sidekiq::Queue.new.find(params[:id])
    job=Sidekiq::Status.delete params[:id]
    job.clear
    job.each do |j|
      j.delete
      redirect_to(root_path,notice: "Job " + j.klass + " " + j.args.to_s + " Deleted Successfully")
    end
    
  end
  
  def cancelalljobs
    job=Sidekiq::Queue.new
    job.clear
    redirect_to(root_path,notice: "All Jobs Deleted")
  end
end