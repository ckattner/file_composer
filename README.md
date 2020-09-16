# File Composer

[![Gem Version](https://badge.fury.io/rb/file_composer.svg)](https://badge.fury.io/rb/file_composer) [![Build Status](https://travis-ci.org/bluemarblepayroll/file_composer.svg?branch=master)](https://travis-ci.org/bluemarblepayroll/file_composer) [![Maintainability](https://api.codeclimate.com/v1/badges/5360d687b0e93a4c7cf5/maintainability)](https://codeclimate.com/github/bluemarblepayroll/file_composer/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/5360d687b0e93a4c7cf5/test_coverage)](https://codeclimate.com/github/bluemarblepayroll/file_composer/test_coverage) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

The library can serve as a foundation for creating a composable and declarative file creation API.  Out of the box, it only provides for the creation of text files and zip archives.  Within zip archives you can compose N number of nested zip archives and text files.  It is designed to first write to disk, then move the written files elsewhere, give then store passed in.  This library is intended to be extended by registering your own document types and then using File Composer as a higher-order configuration layer.

## Installation

To install through Rubygems:

````bash
gem install file_composer
````

You can also add this to your Gemfile:

````bash
bundle add file_composer
````

## Examples

### Writing Text Files

The simplest way to start would be to write a couple text files.  We declare this as:

````ruby
config = {
  documents: [
    {
      type: :text,
      filename: 'hello.txt',
      data: 'hello world!'
    },
    {
      type: :text,
      filename: 'hello2.txt',
      data: 'hello world again!'
    }
  ]
}
````

And then execute it:

````ruby
blueprint = FileComposer::Blueprint.make(config)

results = blueprint.write!
````

This would generate two files within the current relative path.

### Configuring the Temporary Store

In the example above, we did not specify a temporary directory to write the file to.  We can do this simply by passing in a path as the first argument to `Blueprint#write!`:

````ruby
temp_path = File.join('tmp', 'file_composer')
blueprint = FileComposer::Blueprint.make(config)

results = blueprint.write!(temp_path)
````

The two files should now be located in `tmp/file_composer` within the relative path.

### Writing to Permanent Storage

The second argument for `Blueprint#write!` can be a Ruby object instance that responds to `move!(local_filename)` and returns the permanent location.  By default this library only ships with two stores:

* **FileComposer::Stores::Null**: perform no move and return the temporary file path.
* **FileComposer::Stores::Local**: perform a file move and return the new file path.  The file path will also be sharded using the inputted date (defaults to the current date UTC).  The sharding helps ensure a more even distribution of files so one directory does not end up with all the files.

An example using a local store would be:

````ruby
root      = 'storage'
store     = FileComposer::Stores::Local.new(root: root)
temp_path = File.join('tmp', 'file_composer')
blueprint = FileComposer::Blueprint.make(config)

results = blueprint.write!(temp_path, store)
````

This will now produce two files within a `storage/YYYY/MM/DD` directory in the relative path.  These files were initially written within the temporary store, but then moved after completion.

### Custom Stores

A store can be any Ruby object instance that responds to `move!(local_filename)` and returns the permanent location.  For example, you may choose to implement a custom one that moves files to cloud-based storage (i.e. Amazon S3).

### Writing Zip Archives

Say we wanted to also include a zip archive of some other files, we could update our configuration from above to:

````ruby
config = {
  documents: [
    {
      type: :text,
      filename: 'hello.txt',
      data: 'hello world!'
    },
    {
      type: :text,
      filename: 'hello2.txt',
      data: 'hello world again!'
    },
    {
      type: :zip,
      filename: 'hello3.zip',
      blueprint: {
        documents: [
          {
            type: :text,
            filename: 'hello4.txt',
            data: 'hello world again... again!'
          }
        ]
      }
    }
  ]
}
````

And then execute it:

````ruby
blueprint = FileComposer::Blueprint.make(config)

results = blueprint.write!
````

This would now generate three files within the current relative path.  Some notes:

* The zip archive document type allows for a fully nested hierarchy, where you can have zip archives within zip archives.
* Files within the same level need to have unique, case-insensitive filenames or else an error will be raised.

### Plugging in Custom Documents

The documents, text files and zip archives, are meant to serve as 'core' documents.  Consumer applications will not find much value in these types by themselves.  The class `FileComposer::Documents` is a factory that is able to have document types plugged in using the [acts_as_hashable_factory](https://github.com/bluemarblepayroll/acts_as_hashable) API.

## Contributing

### Development Environment Configuration

Basic steps to take to get this repository compiling:

1. Install [Ruby](https://www.ruby-lang.org/en/documentation/installation/) (check file_composer.gemspec for versions supported)
2. Install bundler (gem install bundler)
3. Clone the repository (git clone git@github.com:bluemarblepayroll/file_composer.git)
4. Navigate to the root folder (cd file_composer)
5. Install dependencies (bundle)

### Running Tests

To execute the test suite run:

````bash
bundle exec rspec spec --format documentation
````

Alternatively, you can have Guard watch for changes:

````bash
bundle exec guard
````

Also, do not forget to run Rubocop:

````bash
bundle exec rubocop
````

### Publishing

Note: ensure you have proper authorization before trying to publish new versions.

After code changes have successfully gone through the Pull Request review process then the following steps should be followed for publishing new versions:

1. Merge Pull Request into master
2. Update `lib/file_composer/version.rb` using [semantic versioning](https://semver.org/)
3. Install dependencies: `bundle`
4. Update `CHANGELOG.md` with release notes
5. Commit & push master to remote and ensure CI builds master successfully
6. Run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Code of Conduct

Everyone interacting in this codebase, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bluemarblepayroll/file_composer/blob/master/CODE_OF_CONDUCT.md).

## License

This project is MIT Licensed.
