# Roistat

Ruby wrapper for the [Roistat REST API](https://help-ru.roistat.com/API/methods/about/).

Use it to call Roistat project endpoints with an API key and project id — for example leads, call tracking, and other methods from the official docs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "roistat"
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install roistat
```

## Usage

### Rails

```bash
bundle add roistat
rails generate roistat:install
```

Set `ROISTAT_API_KEY` and `ROISTAT_PROJECT_ID`, then:

```ruby
Roistat.client.get("project/calltracking/phone/list")
Roistat.client.post("project/events/send", body: {name: "purchase"})
```

### Explicit client

```ruby
client = Roistat::Client.new(api_key: "…", project: "12345")
client.get("project/calltracking/phone/list")
```

### Account-level calls (API key only)

```ruby
client = Roistat::Client.new(api_key: "…", project_required: false)
client.get("user/projects")
```

The gem always sends the API key via the `Api-key` header (never as a `key` query param). High-level resource methods will land in later releases; use `#get` / `#post` / `#request` for any documented path today.

See the [Roistat API documentation](https://help-ru.roistat.com/API/methods/about/) for endpoints and parameters.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake` to run the specs and RuboCop. You can also run `bin/console` for an interactive prompt.

Install Lefthook once so pre-commit hooks run RuboCop and RSpec:

```bash
bundle exec lefthook install
```

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alec-c4/roistat.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
