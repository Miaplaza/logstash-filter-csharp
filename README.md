A logstash filter to parse C# stack traces and exception messages.

Running Tests
=============

The tests live in `spec/`. To run them, do something like

```
bundle install
bundle exec rspec
```

If this does not work, there might be a problem with your jruby setup. You
might want to get RVM and run something like this first
```
rvm install jruby
rvm use jruby
gem install bundler
```
