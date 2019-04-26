require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  def setup
    @base_title = I18n.t "label.rail_tuts"
  end

  test "full title helper" do
    assert_equal full_title(""), @base_title.to_s
    assert_equal full_title("Help"), "Help | #{@base_title}"
    assert_equal full_title("Contact"), "Contact | #{@base_title}"
  end
end
