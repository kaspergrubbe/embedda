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
"String heheh http://www.youtube.com/watch?v=BVtYSy83XXw yeah".embedda
=> "String heheh <iframe width=\"560\" height=\"315\" src=\"http://www.youtube.com/embed/BVtYSy83XXw\" frameborder=\"0\" allowfullscreen></iframe> yeah"
```

If you need only one of the parsers you can do like this:

```ruby
"String heheh http://www.youtube.com/watch?v=BVtYSy83XXw yeah".embedda(:filters => :youtube)
=> "String heheh <iframe width=\"560\" height=\"315\" src=\"http://www.youtube.com/embed/BVtYSy83XXw\" frameborder=\"0\" allowfullscreen></iframe> yeah"
```

This is the default behavoir:

```ruby
"String heheh http://www.youtube.com/watch?v=BVtYSy83XXw yeah".embedda(:filters => [:youtube, :vimeo])
=> "String heheh <iframe width=\"560\" height=\"315\" src=\"http://www.youtube.com/embed/BVtYSy83XXw\" frameborder=\"0\" allowfullscreen></iframe> yeah"
```

You can enforce https URLs (useful on SSL-secured sites):

```ruby
"String heheh http://www.youtube.com/watch?v=BVtYSy83XXw yeah".embedda(ssl: true)
=> "String heheh <iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/BVtYSy83XXw\" frameborder=\"0\" allowfullscreen></iframe> yeah"
```

You can set video width and height with proper settings:

```ruby
"http://www.youtube.com/watch?v=BVtYSy83XXw yeah".embedda(video_width: 600, video_height: 300)
=> "String heheh <iframe width=\"600\" height=\"300\" src=\"https://www.youtube.com/embed/BVtYSy83XXw\" frameborder=\"0\" allowfullscreen></iframe> yeah"
```

You can set vimeo query string with `vimeo_url` option:

```ruby
"http://vimeo.com/42620553".embedda(:vimeo_url => {:title => 0, :byline => 0, :portrait => 0, :color => "42b7ed"})
=> %q{<iframe src="http://player.vimeo.com/video/20241459?title=0&byline=0&portrait=0&color=42b7ed" width="560" height="315" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>}
```

## Supported embeds

Currently embedda can embed the following formats:

* Youtube
* Vimeo
* Soundcloud

## Links

Rubygems: https://rubygems.org/gems/embedda
