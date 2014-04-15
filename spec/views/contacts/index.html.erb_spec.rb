require 'spec_helper'

describe "contacts/index" do
  before(:each) do
    assign(:contacts, [
      stub_model(Contact,
        :user_id => 1,
        :friend_name => "Friend Name",
        :friend_email => "Friend Email"
      ),
      stub_model(Contact,
        :user_id => 1,
        :friend_name => "Friend Name",
        :friend_email => "Friend Email"
      )
    ])
  end

  it "renders a list of contacts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Friend Name".to_s, :count => 2
    assert_select "tr>td", :text => "Friend Email".to_s, :count => 2
  end
end
