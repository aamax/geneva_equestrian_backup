require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation, :admin,
                  :street, :city, :state, :zip, :homephone, :cellphone, 
                  :startdate, :fname, :lname
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  startdate_regex = /[12][09][\d]{2}/
  
  validates   :name,  :presence => true,
              :length   => { :maximum => 50 }
            
  validates   :fname, :presence => true
  
  validates   :lname, :presence => true            

        
  validates   :email, :presence => true,  
            :format => { :with => email_regex },
            :uniqueness => { :case_sensitive => false }
      
  validates   :password,  :presence => true, :on => :create
  
   validates   :password,  :confirmation => true ,
                 :length => { :within => 6..40 }, :if => :password_is_not_blank?
                
  validates   :startdate, :presence => true,
              :format => { :with => startdate_regex }
  
  before_save :encrypt_password
  before_save :format_phoneNumbers
    
  default_scope :order => "name asc" 
    
  def password_is_not_blank?
    !password.blank?
  end
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    (user && user.has_password?(submitted_password)) ? user : nil
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
    
  private
    def encrypt_password
      if !password.blank?
        self.salt = make_salt if new_record?
        self.encrypted_password = encrypt(password)
      end
    end
    
    def encrypt(aString)
      secure_hash("#{salt}--#{aString}") 
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(aString)
      Digest::SHA2.hexdigest(aString)
    end
end


