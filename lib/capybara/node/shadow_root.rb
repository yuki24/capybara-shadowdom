require 'capybara/node/element'

class Capybara::Node::ShadowRoot < Capybara::Node::Element
  def host
    evaluate_script("this.host")
  end

  def text(type = nil, normalize_ws: false)
    case base.class.to_s
    when "Capybara::Selenium::SafariNode", "Capybara::Cuprite::Node"
      all("*")
        .select { |node| node.send(:parent).nil? }
        .map { |node| node.text(type, normalize_ws: normalize_ws) }
        .join
    else # For Selenium + Chrome and Selenium + Edge:
      all("*")
        .map { |node| node.text(type, normalize_ws: normalize_ws) }
        .join
    end
  end

  def tag_name
    host.tag_name
  end
end
