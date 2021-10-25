# Shadow DOM support for Capybara

The `capybara-shadowm` gem adds basic support for the [Shadow DOM](https://developer.mozilla.org/en-US/docs/Web/Web_Components/Using_shadow_DOM) to Capybara.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capybara-shadowdom', git: "https://github.com/yuki24/capybara-shadowdom.git"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install capybara-shadowdom

## Usage

Given the custom element:

```html
<awesome-element>
  <!-- #shadow-root start -->
  <span>Hello shadow world!</span>

  <input type="text" id="user_name">
  <!-- #shadow-root end -->
</awesome-element>
```

You will be able to do:

```ruby
within custom_element.shadow_root do
  # Displays "Hello shadow world!":
  puts page.text

  # Asserts the text within the element:
  assert_text "Hello shadow world!"

  # Input elements within the shadow DOM will also be accessible:
  fill_in "#user_name", with: "awesome@example.org"
end
```

## Browser Support

 * Selenium:
   * ✅ Edge
   * ✅ Chrome
   * ✅ Safari
   * ❌ Firefox

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can
also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the
version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version,
push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/capybara-shadowdom. This project
is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the
[code of conduct](https://github.com/[USERNAME]/capybara-shadowdom/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Capybara::Shadowdom project's codebases, issue trackers, chat rooms and mailing lists
is expected to follow the
[code of conduct](https://github.com/[USERNAME]/capybara-shadowdom/blob/master/CODE_OF_CONDUCT.md).
