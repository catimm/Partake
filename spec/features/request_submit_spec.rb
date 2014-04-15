require 'spec_helper'

describe "Request submit" do

  describe "request" do 

    before { visit root_path }

    let(:submit) { "Request an invite" }
    describe "with invalid information" do 
      it "should not create a request" do 
        expect { click_button submit }.not_to change(Request, :count)
      end 
    end 

    describe "with valid information" do 
      before do 
        fill_in "name",         with: "Example User"
        fill_in "email",        with: "user@example.com"
      end 

      it "should create a user" do 
        expect { click_button submit }.to change(Request, :count).by(1)
      end 
    end 
  end 

end