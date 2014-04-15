require 'spec_helper'

describe "contacts/edit" do
  before(:each) do
    @contact = assign(:contact, stub_model(Contact,
      :user_id => 1,
      :friend_name => "MyString",
      :friend_email => "MyString"
    ))
  end

  it "renders the edit contact form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => contacts_path(@contact), :method => "post" do
      assert_select "input#contact_user_id", :name => "contact[user_id]"
      assert_select "input#contact_friend_name", :name => "contact[friend_name]"
      assert_select "input#contact_friend_email", :name => "contact[friend_email]"
    end
  end
end
