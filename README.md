# Certsweeper

Certsweeper is clean up expired server certificates uploaded to AWS.

## Installation

    $ gem install certsweeper

## Usage

list expired server certificats

```
$ certsweeper list --profile `your_aws_profile`
www.example.com-20150708	2015-08-10 06:31:12 UTC
www.example.com-20150808	2015-09-10 06:31:12 UTC
www.example.com-20150908	2015-10-10 06:31:12 UTC
www.example.com-20151008	2015-11-10 06:31:12 UTC
```

remove expired server certificates

```
$ certsweeper remove --profile `your_aws_profile` --all
remove: www.example.com-20150708
remove: www.example.com-20150808
remove: www.example.com-20150908
remove: www.example.com-20151008
```

remove one's

```
$ certsweeper remove --profile `your_aws_profile` --certificate-name www.example.com-20150708
remove: www.example.com-20150708
```

get help

```
$ certsweeper help
Commands:
  certsweeper help [COMMAND]  # Describe available commands or one specific command
  certsweeper list            # List expired and not assigned server certificates
  certsweeper remove          # Remove expired and not assignd server certificates

Options:
  p, [--profile=PROFILE]                                   # Load credentials by profile name from shared credentials file.
  k, [--access-key-id=ACCESS_KEY_ID]                       # AWS access key id.
  s, [--secret-access-key=SECRET_ACCESS_KEY]               # AWS secret access key.
  r, [--region=REGION]                                     # AWS region.
      [--shared-credentials-path=SHARED_CREDENTIALS_PATH]  # AWS shared credentials path.
  v, [--verbose], [--no-verbose]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec certsweeper` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/certsweeper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

