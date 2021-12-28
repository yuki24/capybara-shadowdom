# frozen_string_literal: true

require "test_helper"

class Capybara::ShadowDOMTest < ShadowDOMTest
  def setup
    visit "/"
  end

  def test_shadow_root
    assert_equal "Name", find("sl-input").shadow_root.text

    within find("sl-input").shadow_root do
      assert_equal "Name", page.text
    end
  end

  def test_shadow_host
    assert_equal find("sl-input"), find("sl-input").shadow_root.host
  end

  def test_shadow_root_with_normal_element
    assert_nil find("body").shadow_root
  end
end
