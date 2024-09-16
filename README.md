# Effective Postmark

A mailer concern to capture `Postmark::InactiveRecipientError` and mark users as bounced.

Uses the postmark API to reactivate users. Includes a datatable report of all inactive users.

## effective_postmark 1.0

This is the 1.0 series of effective_postmark.

This requires Twitter Bootstrap 4.

## Getting Started

Add to your Gemfile:

```ruby
gem 'haml-rails'
gem 'effective_postmark'
```

Run the bundle command to install it:

```console
bundle install
```

Add the following to your user model:

```ruby
class User
  effective_postmark_user
end
```

And add two database fields to your user model:

```ruby
class AddEffectivePostmarkFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :email_delivery_error, :string
    add_column :users, :email_delivery_error_at, :datetime
  end
end
```

Then migrate the database:

```ruby
rake db:migrate
```

## Admin View

To add an admin alert when the user has been marked inactive with a link to reactivate

```ruby
= effective_postmark_admin_alert(current_user, from: 'My Site')
```

## Dashboard View

To add an alert when the user has been marked inactive

```ruby
= effective_postmark_alert(current_user, from: 'My Site')
```

## Devise Password Reset

If you want to include the inactive alert on the devise reset password page:

```ruby
class Users::PasswordsController < Devise::PasswordsController
  after_action(only: :create) do
    if resource.email_delivery_error.present?
      flash.delete(:notice)
      flash[:danger] = view_context.effective_postmark_alert(resource, from: 'My Site', html_class: '')
    end
  end
end
```

## Inactive Recipients Report

Add a link to the admin report:

```ruby
= nav_link_to 'Email Delivery Errors', effective_postmark.email_delivery_errors_admin_postmark_reports_path
```

### Permissions

Give the following permissions to your admin user:

```ruby
can :admin, :effective_postmark
can(:postmark_reactivate, User) { |user| user.email_delivery_error.present? }
can(:index, Admin::ReportEmailDeliveryErrorsDatatable)
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
