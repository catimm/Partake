require 'spec_helper'

describe "PackageTests" do
  
  describe "weekly package page" do
    
    it "should have the content 'Partake'" do
      visit '/package_test/week'
      page.should have_content('Partake')
    end
  end
end
