embedda
=======

Easily embed content in a string from Youtube or Vimeo by writing a simple string

## Tests:

[![Build Status](https://travis-ci.org/kaspergrubbe/embedda.png)](https://travis-ci.org/kaspergrubbe/embedda)

## Install

Add this to your `Gemfile`:

```ruby
gem 'embedda'
```

And remember to `bundle`

## Usage

This gem adds `String#embedda` to Ruby strings. You use it like this:

```ruby
[2] pry(main)> "String heheh http://www.youtube.com/watch?v=BVtYSy83XXw yeah".embedda
=> "String heheh <iframe width=\"560\" height=\"315\" src=\"http://www.youtube.com/embed/BVtYSy83XXw\" frameborder=\"0\" allowfullscreen></iframe> yeah"
```

If you need only one of the parsers you can do like this:

```ruby
[2] pry(main)> "String heheh http://www.youtube.com/watch?v=BVtYSy83XXw yeah".embedda(:filters => :youtube)
=> "String heheh <iframe width=\"560\" height=\"315\" src=\"http://www.youtube.com/embed/BVtYSy83XXw\" frameborder=\"0\" allowfullscreen></iframe> yeah"
```

This is the default behavoir:

```ruby
[2] pry(main)> "String heheh http://www.youtube.com/watch?v=BVtYSy83XXw yeah".embedda(:filters => [:youtube, :vimeo])
=> "String heheh <iframe width=\"560\" height=\"315\" src=\"http://www.youtube.com/embed/BVtYSy83XXw\" frameborder=\"0\" allowfullscreen></iframe> yeah"
```

## Supported embeds

Currently embedda can embed the following formats:

* Youtube
* Vimeo
* Soundcloud

## Links

Rubygems: https://rubygems.org/gems/embedda