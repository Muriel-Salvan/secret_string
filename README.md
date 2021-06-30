[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

# secret_string - Remove secrets (passwords, keys...) from memory

## Description

This Rubygem gives you ways to clean sensitive data (secrets, SSH keys, passwords) from your Ruby String variables in memory.

## Install

Via gem command line:

```bash
gem install secret_string
```

If using `bundler`, add this in your `Gemfile`:

```ruby
gem 'secret_string'
```

## Usage

### With a protecting scope

The simplest and more robust way to use it is with the `SecretString.protect` method that gives a scope for a secret to be used from a String and will make sure this secret is removed from memory when code ends.

Example:
```ruby
require 'secret_string'

secret = 'P4$Sw0rD' # Usually retrieved from a file, ENV var, user input...

# Create the protected scope
SecretString.protect(secret) do |secret_string|

  # Let's try to display the password
  puts "Password on screen is #{secret_string}"
  # => Password on screen is XXXXX

  # Its value can still be accessed using to_unprotected
  puts "If we REALLY want to display it or use its real secret value somewhere: #{secret_string.to_unprotected}"
  # => If we REALLY want to display it or use its real secret value somewhere: P4$Sw0rD

end

# Now that we are out of the protected scope, let's try leetch its value again!
puts "Outside of protection, my secret from memory is now #{secret}"
# => Outside of protection, my secret from memory is now
```

You can also control the silenced secret, in case you still need to display it in logs or messages:
```ruby
require 'secret_string'

SecretString.protect('P4$Sw0rD', silenced_str: '<FAKE PASSWORD>') do |secret_string|
  # Let's try to display the password
  puts "Password on screen is #{secret_string}"
  # => Password on screen is <FAKE PASSWORD>
end
```

### With the `SecretString` class

If you need more control (like having a simple scope is not enough), you can directly use the `SecretString` class to protect your strings.
If you do so, don't forget to call the `erase` method to clean their data, and make sure you didn't clone the secret in other variables.

Example:
```ruby
require 'secret_string'

my_secret = SecretString.new('P4$Sw0rD', silenced_str: '<FAKE PASSWORD>')

puts "My secret handled without precaution is #{my_secret}"
# => My secret handled without precaution is <FAKE PASSWORD>

puts "My secret when I REALLY want its value is #{my_secret.to_unprotected}"
# => My secret when I REALLY want its value is P4$Sw0rD

my_secret.erase

puts "My secret after being erased is #{my_secret.to_unprotected}"
# => My secret after being erased is
```

### Dealing directly with original Strings

You can erase any Ruby String using `SecretString.erase` method:

```ruby
require 'secret_string'

my_secret = 'P4$Sw0rD'

puts "My secret before erase is #{my_secret}"
# => My secret before erase is P4$Sw0rD

SecretString.erase(my_secret)

puts "My secret after being erased is #{my_secret}"
# => My secret after being erased is
```

The `erase` and `to_unprotected` methods have also been added to the core String class so that you can treat both `String` and `SecretString` easily within your code logic (no need to plague your code with `if str.is_a?(SecretString)`). Those methods won't do or change anything to the normal Ruby Strings.

Example:
```ruby
require 'secret_string'

strings = [
  'Normal string',
  SecretString.new('Secret: P4$Sw0rD', silenced_str: 'Secret: NO WAY')
]

puts "My strings are: #{strings}"
# => My strings are: ["Normal string", "Secret: NO WAY"]

puts "My unprotected strings are: #{strings.map(&:to_unprotected)}"
# => My unprotected strings are: ["Normal string", "Secret: P4$Sw0rD"
```

## Change log

Please see [CHANGELOG](CHANGELOG.md) for more information on what has changed recently.

## Testing

Automated tests are done using rspec.

To execute them, first install development dependencies:

```bash
bundle install
```

Then execute rspec

```bash
bundle exec rspec
```

Manual testing has been done using `gdb` to effectively check that a Ruby process dumping its full memory on disk does not reveal secrets once erased by `SecretString` (tested on Ruby 2.7).

## Contributing

Any contribution is welcome:
* Fork the github project and create pull requests.
* Report bugs by creating tickets.
* Suggest improvements and new features by creating tickets.

## Credits

- [Muriel Salvan](https://x-aeon.com/muriel)

## License

The BSD License. Please see [License File](LICENSE.md) for more information.
