# == Schema Information
#
# Table name: requests
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  city       :string(255)
#  state      :string(255)
#  zip        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Request do

  before do
    @request = Request.new(name: "Example request", email: "request@example.com")
  end
  
  subject { @request }
  
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  
  it { should be_valid }
  
  describe "when name is not present" do
    before { @request.name = " " }
    it { should_not be_valid }
  end
  
  describe "when email is not present" do 
    before { @request.email = " " }
    it { should_not be_valid }
  end
  
  describe "when name is too long" do 
    before { @request.name = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when email format is invalid" do 
    it "should be invalid" do 
      addresses = %w[request@foo,com request_at_foo.org example.request@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @request.email = invalid_address
        @request.should_not be_valid
      end 
    end 
  end 

  describe "when email format is valid" do 
    it "should be valid" do 
      addresses = %w[request@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @request.email = valid_address
        @request.should be_valid
      end 
    end 
  end 
  
  describe "when email address is already taken" do 
    before do 
      request_with_same_email = @request.dup
      request_with_same_email.email = @request.email.upcase
      request_with_same_email.save
    end 

    it { should_not be_valid }
  end

end
