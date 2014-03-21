require 'spec_helper'

describe "contacts/show" do
  before(:each) do
    @contact = assign(:contact, stub_model(Contact,
      :user_id => 1,
      :friend_name => "Friend Name",
      :friend_email => "Friend Email"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Friend Name/)
    rendered.should match(/Friend Email/)
  end
end
