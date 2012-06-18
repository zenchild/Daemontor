# Daemontor

* http://github.com/zenchild/daemontor

## DESCRIPTION

If you are looking for a package that allows you to simply run a process in the background, Deamontor can help you out.  If you're looking for a package that does threading and fine grain process control you'll probably want to look elsewhere.

## DEPENDENCIES

This module depends on the fork system call so it will not run on a Windows OS.

## SYNOPSIS

```ruby
require 'rubygems'
require 'daemontor'
class Test
  include Daemontor
  def initialize
    daemonize!
  end
end
Test.new
```

**Also see code in examples/**

## INSTALL

`gem install daemontor` or `bundle install`

## LICENSE
This project is licensed under the MIT license (See LICENSE for details).