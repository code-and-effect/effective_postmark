
# Effective Postmark

A mailer concern to capture `Postmark::InvalidRecipientError` and mark users as bounced.

Uses the postmark API to resubscribe users.

Reports for all bounced users

## effective_postmark 1.0

This is the 1.0 series of effective_postmark.

This requires Twitter Bootstrap 4.

## Getting Started

Add to your Gemfile:

```ruby
gem 'haml-rails' # or try using gem 'hamlit-rails'
gem 'effective_postmark'
```

Run the bundle command to install it:

```console
bundle install
```

Then run the generator:

```ruby
rails generate effective_postmark:install
```

The generator will install an initializer which describes all configuration options and creates a database migration.

If you want to tweak the table name (to use something other than the default 'postmark'), manually adjust both the configuration file and the migration now.

Then migrate the database:

```ruby
rake db:migrate
```

And import the provided welcome email template:

```ruby
rake effective_postmark:import
```

## Admin View

To manage the content of the email templates, navigate to `/admin/postmark` or add,

`link_to 'Postmark', effective_postmark.admin_postmark_path` to your menu.

## Authorization

All authorization checks are handled via the effective_resources gem found in the `config/initializers/effective_resources.rb` file.


### Permissions

To allow a user to see the admin area, using CanCan:

```ruby
can :admin, :effective_postmark
```

## License

MIT License. Copyright [Code and Effect Inc.](http://www.codeandeffect.com/)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Bonus points for test coverage
6. Create new Pull Request
