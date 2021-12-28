require 'capybara/node/element'

class Capybara::Node::ShadowRoot < Capybara::Node::Element
  def host
    evaluate_script("this.host")
  end

  def text(type = nil, normalize_ws: false)
    all("*")
      .map {|node| node.text(type, normalize_ws: normalize_ws) }
      .join
  end
end
