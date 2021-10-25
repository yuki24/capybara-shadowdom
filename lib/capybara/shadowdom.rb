# frozen_string_literal: true

require_relative "node/shadow_root"
require_relative "shadowdom/version"

module Capybara
  module Shadowdom
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
    # within custom_element.shadow_root do
    #   # Displays "Hello shadow world!":
    #   puts page.text
    #
    #   # Asserts the text within the element:
    #   assert_text "Hello shadow world!"
    #
    #   # Input elements within the shadow DOM will also be accessible:
    #   fill_in "#user_name", with: "awesome@example.org"
    # end
    #
    def shadow_root
      root_node = evaluate_script("this.shadowRoot")

      if root_node
        Capybara::Node::ShadowRoot.new(session, root_node.base, nil, nil)
      else
        self
      end
    end

    Capybara::Node::Element.include Shadowdom
  end
end
