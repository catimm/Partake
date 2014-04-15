require 'spec_helper'

describe "contacts/new" do
  before(:each) do
    assign(:contact, stub_model(Contact,
      :user_id => 1,
      :friend_name => "MyString",
      :friend_email => "MyString"
    ).as_new_record)
  end

  it "renders new contact form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => contacts_path, :method => "post" do
      assert_select "input#contact_user_id", :name => "contact[user_id]"
      assert_select "input#contact_friend_name", :name => "contact[friend_name]"
      assert_select "input#contact_friend_email", :name => "contact[friend_email]"
    end
  end
end
