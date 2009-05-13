class Registration < ActiveRecord::Base
  belongs_to :school
  belongs_to :session
  belongs_to :student
  has_many :registered_days, :dependent => :destroy
  has_many :registered_dates, :dependent => :destroy
  has_many :registered_options, :dependent => :destroy
  has_many :registered_group_classes, :dependent => :destroy
end
