# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  first_name             :string(255)
#  last_name              :string(255)
#  stripe_customer_id     :string(255)
#  authentication_token   :string(255)
#  mobile_number          :integer
#  role                   :string(255)      default("registered"), not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_mobile_number         (mobile_number)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'securerandom'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :mobile_number, :role
  # attr_accessible :title, :body

  has_many :ratings
  has_many :fb_friends
  has_many :contacts
  has_many :friends
  has_many :authentications
  has_many :package_responses
  has_many :commons

  before_save :ensure_authentication_token # TODO anshuman 10/18/2013 when should we reset auth token?


  validates :role, :presence => true, :inclusion => { :in => [UserRole::Registered, UserRole::Unregistered]}
  
  def self.common_update
    @user = User.all
    @user.each do |u|
      Common.update(u.email).deliver
    end
  end
  
  def apply_omniauth(omni)
    authentications.build(:provider => omni['provider'],
    :uid => omni['uid'],
    :token => omni['credentials']['token'],
    :token_secret => omni['credentials']['secret'])
  end
  
  def ensure_authentication_token
    if self.authentication_token.blank?
      new_token = ""
      loop do
        new_token = SecureRandom.base64(15).tr('+/=lIO0', 'pqrsxyz')
        # break token unless to_adapter.find_first({ :authentication_token => token })
        break unless User.where(:authentication_token => new_token).count > 0
      end
      self.authentication_token = new_token
    end
  end

    
  # let devise know that a password isn't required if the user logs in through Facebook
  def password_required?
    (authentications.empty? || !password.blank?) && super
  end
  
  # tell devise to not show the password field for the edit settings page if user logs in through Facebook
  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end
end
