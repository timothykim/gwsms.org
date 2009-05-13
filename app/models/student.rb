class Student < ActiveRecord::Base
  belongs_to :users
  has_many :registrations
  
  def to_s
    [self.first_name, self.last_name].join(" ")
  end
  
  #embedding html here might be bad -_-;; oh well...
  def registered?(sess)
    return true if self.registrations.find(:first, :conditions => {:session_id => sess.id})
    return false
  end
  
  def confirmed?(sess)
    return self.registrations.find(:first, :conditions => {:session_id => sess.id}).confirmed
  rescue
    return false
  end
  
  def current_or_new_registration(sess)
    reg = self.registrations.find(:first, :conditions => {:session_id => sess.id})
    if reg.nil?
      reg = self.registrations.new
    end
    return reg
  end
  
  def status(sess)
    reg = self.registrations.find(:first, :conditions => {:session_id => sess.id})
    unless reg
      return "<img src=\"/images/icons/exclamation.png\" class=\"icon\"> Not Registered" 
    end
    
    if reg.confirmed
      return "<img src=\"/images/ok.png\" class=\"icon\"> Registered!" 
    else
      return "<img src=\"/images/icons/processing.png\" class=\"icon\"> Processing..."
    end
  end
end
