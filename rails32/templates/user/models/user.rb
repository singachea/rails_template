class User < ActiveRecord::Base
  #extend ModelUtilities
  ROLES = %w(admin member)
  SORT_KEYS = { :asc => ["first_name", "last_name", "email", "role", "activated"], :desc => ["id", "locked"], :default => "id desc"}
  
  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation
  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation, :role, :locked, :activated, :as => :admin

  has_secure_password
  before_create :add_random_password_recoverable
  before_create { generate_token(:auth_token) }

  validates :email, :uniqueness => true, :allow_blank => true, :format => { :with => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i }
  
  validates :password, :length => { :minimum => 6 }, :allow_blank => true
  validates :role, :presence => true, :inclusion => { :in => ROLES}


  def is_admin?
    self.role == "admin"
  end

  def is? r
    self.role == r.to_s
  end

  def display_name
    return email if first_name.nil? || last_name.nil?
    "#{first_name} #{last_name}"
  end

private  
  
  def generate_token(column)  
    begin  
      self[column] = SecureRandom.urlsafe_base64  
    end while User.exists?(column => self[column])  
  end 

  def add_random_password_recoverable
    self.password_recoverable = SecureRandom.uuid.gsub("-", "")
  end
  
end
