# Litetags

[![Gem Version](https://badge.fury.io/rb/litetags.svg)](https://rubygems.org/gems/litetags)
[![Gem Downloads](https://img.shields.io/gem/dt/litetags)](https://rubygems.org/gems/litetags)
![Tests](https://github.com/litestack-ruby/litetags/actions/workflows/main.yml/badge.svg)
![Coverage](https://img.shields.io/badge/code_coverage-80%25-green)

Fast & simple Rails ActiveRecord model tagging using native SQLite functionality. This is a port of [@hopsoft](https://twitter.com/hopsoft)'s [tag_columns](https://github.com/hopsoft/tag_columns) gem, which is uses native PostgreSQL functionality.

This gem makes it easy to:

* Assign categories to your database records.
* Assign multiple groups to user records
* Assign categories to blog posts et al.
* etc...

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add litetags

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install litetags

## Usage

```ruby
# db/migrate/TIMESTAMP_add_groups_to_user.rb
class AddGroupsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :groups, :json, null: false, default: []
    add_check_constraint :users, "JSON_TYPE(groups) = 'array'", name: 'user_groups_is_array'
  end
end
```

```ruby
# app/models/user.rb
class User < ApplicationRecord
  include Litetags
  tag_columns :groups
end
```

```ruby
user = User.find(1)

# assigning tags
user.groups << :reader
user.groups << :writer
user.save

# checking tags
is_writer            = user.has_group?(:writer)
is_reader_or_writer  = user.has_any_groups?(:reader, :writer)
is_reader_and_writer = user.has_all_groups?(:reader, :writer)

# finding tagged records
assigned                = User.with_groups
unassigned              = User.without_groups
writers                 = User.with_any_groups(:writer)
non_writers             = User.without_any_groups(:writer)
readers_or_writers      = User.with_any_groups(:reader, :writer)
readers_and_writers     = User.with_all_groups(:reader, :writer)
non_readers_and_writers = User.without_all_groups(:reader, :writer)

# find unique tags across all users
User.unique_groups

# find unique tags for users with the last name 'Smith'
User.unique_groups(last_name: "Smith")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/litestack-ruby/litetags. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/litestack-ruby/litetags/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Litetags project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/litestack-ruby/litetags/blob/main/CODE_OF_CONDUCT.md).
