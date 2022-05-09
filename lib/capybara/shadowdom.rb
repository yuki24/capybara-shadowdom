# frozen_string_literal: true

require_relative "node/shadow_root"
require_relative "shadow_dom/version"

module Capybara
  module ShadowDOM
    ROOT_KEY = "shadow-6066-11e4-a52e-4f735466cecf"

    # Adds a way to retrieve the shadow root object of an element. For example, given the HTML below:
    #
    #   <awesome-element>
    #     <!-- #shadow-root start -->
    #     <span>Hello shadow world!</span>
    #
    #     <input type="text" id="user_name">
    #     <!-- #shadow-root end -->
    #   </awesome-element>
    #
    # Then You will be able to do:
    #
    #   within custom_element.shadow_root do
    #     # Displays "Hello shadow world!":
    #     puts page.text
    #
    #     # Asserts the text within the element:
    #     assert_text "Hello shadow world!"
    #
    #     # Input elements within the shadow DOM will also be accessible:
    #     fill_in "#user_name", with: "awesome@example.org"
    #   end
    #
    def shadow_root
      root_node = synchronize { evaluate_script("this.shadowRoot") }

      return if root_node.nil?

      node = if defined?(::Selenium::WebDriver::ShadowRoot) && root_node.is_a?(::Selenium::WebDriver::ShadowRoot)
               # Selenium >= 4.1.x
               driver.send(:build_node, root_node)
             elsif root_node.is_a?(Hash)
               bridge = session.driver.browser.send(:bridge)

               shadow_key = if defined?(::Selenium::WebDriver::ShadowRoot)
                              # Selenium ~> 4.0.x
                              ::Selenium::WebDriver::ShadowRoot::ROOT_KEY
                            else
                              # Selenium ~> 3.x
                              ROOT_KEY
                            end

               element = ::Selenium::WebDriver::Element.new(bridge, root_node[shadow_key])

               session.driver.send(:build_node, element)
             elsif root_node.is_a?(::Capybara::Node::Element)
               root_node.base
             end

      ::Capybara::Node::ShadowRoot.new(session, node, node, nil)
    end
  end
end

::Capybara::Node::Element.prepend(::Capybara::ShadowDOM)
