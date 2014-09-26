# Editor

A little utility gem that is designed to collect user input through the user's text editor.

This is mostly an extraction from the excellent [pry](http://github.com/pry/pry), but with more generalized functionality

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'editors'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install editor

## Usage

**[docs](http://rubydoc.info/github/paradox460/editor/master/)**

There are 2 main ways of using `Editor.` To open files, and to collect input.

### Files
[`Editor.file`](http://rubydoc.info/github/paradox460/editor/master/Editor.file)
```ruby
Editor.file('/path/to/your/file.rb')
```

### Collecting input
This is what Editor was initially written for

[`Editor.temp`](http://rubydoc.info/github/paradox460/editor/master/Editor.temp)
```ruby
Editor.temp('String to put into the tempfile before the user edits it')
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/editors/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License
```
Copyright (c) 2014 Jeff Sandberg

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
 ```
