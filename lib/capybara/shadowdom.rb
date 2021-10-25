# frozen_string_literal: true

require_relative "node/shadow_root"
require_relative "shadowdom/version"

module Capybara
  module Shadowdom
    # Adds a way to retrieve the shadow root object of an element.
    #
    # @example
    #
    #   within all("sl-input")[0].shadow_root do
    #     puts text
    #     assert_text "Email"
    #     fill_in "user[email]", with: "ynishijima@pivotal.io"
    #   end
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
