class Session < ActiveRecord::Base
  has_many :weekly_availablities, :dependent => :destroy
  has_many :session_days, :dependent => :destroy
  has_many :registration_options, :dependent => :destroy
  has_many :registrations
  
  DAY_TYPE = 0
  DATE_TYPE = 1
end
