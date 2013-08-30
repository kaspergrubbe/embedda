require "spec_helper"
require "rack"
require "uri"

require "embedda"

describe Embedda do
  let(:embedda) { described_class.new(@story).embed }

  context "Youtube-link" do
    let(:embed_string) { '<iframe width="560" height="315" src="http://www.youtube.com/embed/dQw4w9WgXcQ" frameborder="0" allowfullscreen></iframe>' }
    let(:https_embed_string) { embed_string.gsub("http", "https") }
    let(:horizontal_embed_string) { embed_string.gsub("560", "200").gsub("315", "400") }

    it "should embed when text have a link" do
      @story = "http://www.youtube.com/watch?v=dQw4w9WgXcQ"
      expect(embedda).to eq(embed_string)
    end

    it "should embed when text have a link with feature_embed" do
      @story = "http://www.youtube.com/watch?feature=player_embedded&v=dQw4w9WgXcQ"
      pending
      expect(embedda).to eq(embed_string)
    end

    it "should embed when also other text is present around link" do
      @story = 'Hello, my name is Kasper: http://www.youtube.com/watch?v=dQw4w9WgXcQ<br/>And I am embedding links'
      expect(embedda).to eq("Hello, my name is Kasper: #{embed_string}<br/>And I am embedding links")
    end

    it "should embed when text include anchor tag to Youtube" do
      @story = '<a href="http://www.youtube.com/watch?v=dQw4w9WgXcQ">Look here for HalfLife3!</a>'
      expect(embedda).to eq(embed_string)
    end

    it "should embed when also other text is present around anchor tag" do
      @story = 'Hello, my name is Kasper: <b><a href="http://www.youtube.com/watch?v=dQw4w9WgXcQ">Look here for HalfLife3!</a><br/></b>And I am embedding links'
      expect(embedda).to eq("Hello, my name is Kasper: <b>#{embed_string}<br/></b>And I am embedding links")
    end

    it "should embed when content is around the link" do
      @story = "\n\nMy suggestions for getting ready for the dreadful monday we all hate:\n\nhttp://www.youtube.com/watch?v=dQw4w9WgXcQ\n\n"
      expect(embedda).to eq("\n\nMy suggestions for getting ready for the dreadful monday we all hate:\n\n#{embed_string}\n\n")
    end

    it "should embed when enabled" do
      @story  = 'Hello, my name is Kasper: <b><a href="http://www.youtube.com/watch?v=dQw4w9WgXcQ">Look here for HalfLife3!</a><br/></b>And I am embedding links'
      embedda = described_class.new(@story, :filters => :youtube).embed
      expect(embedda).to eq("Hello, my name is Kasper: <b>#{embed_string}<br/></b>And I am embedding links")
    end

    it "should not embed when disabled" do
      @story = 'Hello, my name is Kasper: <b><a href="http://www.youtube.com/watch?v=dQw4w9WgXcQ">Look here for HalfLife3!</a><br/></b>And I am embedding links'
      embedda = described_class.new(@story, :filters => :vimeo).embed
      expect(embedda).to eq('Hello, my name is Kasper: <b><a href="http://www.youtube.com/watch?v=dQw4w9WgXcQ">Look here for HalfLife3!</a><br/></b>And I am embedding links')
    end

    it 'should output a https link if ssl option is given' do
      @story = "http://www.youtube.com/watch?v=dQw4w9WgXcQ"
      expect(described_class.new(@story, :ssl => true).embed).to eq(https_embed_string)
    end

    it 'outputs link with proper width and height' do
      @story = "http://www.youtube.com/watch?v=dQw4w9WgXcQ"
      embedda = described_class.new(@story, :video_width => 200, :video_height => 400).embed
      expect(embedda).to eq(horizontal_embed_string)
    end
  end

  context "Vimeo-link" do
    let(:embed_string) { '<iframe src="http://player.vimeo.com/video/20241459" width="560" height="315" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>' }
    let(:https_embed_string) { embed_string.gsub("http", "https") }
    let(:horizontal_embed_string) { embed_string.gsub("560", "200").gsub("315", "400") }
    let(:query_string_embed) { embed_string.gsub("20241459", "20241459?title=0&byline=0&portrait=0&color=42b7ed") }
    let(:no_height_embed) { embed_string.gsub(%q{height="315" }, "") }

    it "should embed when text have a link" do
      @story = "http://vimeo.com/20241459"
      expect(embedda).to eq(embed_string)
    end

    it "should embed when also other text is present around link" do
      @story = 'Hello, my name is Kasper: http://vimeo.com/20241459<br/>And I am embedding links'
      expect(embedda).to eq("Hello, my name is Kasper: #{embed_string}<br/>And I am embedding links")
    end

    it "should embed when text include anchor tag to Vimeo" do
      @story = '<a href="http://vimeo.com/20241459">Look here for HalfLife3!</a>'
      expect(embedda).to eq(embed_string)
    end

    it "should embed when also other text is present around anchor tag" do
      @story = 'Hello, my name is Kasper: <a href="http://vimeo.com/20241459">Look here for HalfLife3!</a><br/>And I am embedding links'
      expect(embedda).to eq("Hello, my name is Kasper: #{embed_string}<br/>And I am embedding links")
    end

    it "should embed when enabled" do
      @story  = 'Hello, my name is Kasper: <a href="http://vimeo.com/20241459">Look here for HalfLife3!</a><br/>And I am embedding links'
      embedda = described_class.new(@story, :filters => :vimeo).embed
      expect(embedda).to eq("Hello, my name is Kasper: #{embed_string}<br/>And I am embedding links")
    end

    it "should not embed when disabled" do
      @story  = 'Hello, my name is Kasper: <a href="http://vimeo.com/20241459">Look here for HalfLife3!</a><br/>And I am embedding links'
      embedda = described_class.new(@story, :filters => :youtube).embed
      expect(embedda).to eq('Hello, my name is Kasper: <a href="http://vimeo.com/20241459">Look here for HalfLife3!</a><br/>And I am embedding links')
    end

    it 'should output a https link if ssl option is given' do
      @story = "http://vimeo.com/20241459"
      expect(described_class.new(@story, :ssl => true).embed).to eq(https_embed_string)
    end

    it 'outputs link with proper width and height' do
      @story = "http://vimeo.com/20241459"
      embedda = described_class.new(@story, :video_width => 200, :video_height => 400).embed
      expect(embedda).to eq(horizontal_embed_string)
    end

    it 'generates iframe with query string' do
      @story = "http://vimeo.com/20241459"
      vimeo_params = {:title => 0, :byline => 0, :portrait => 0, :color => "42b7ed"}
      embedda = described_class.new(@story, :vimeo_params => vimeo_params).embed
      vimeo_expected_params = {"title" => "0", "byline" => "0", "portrait" => "0", "color" => "42b7ed"}
      Rack::Utils.parse_query( URI.parse(embedda.split('"')[1]).query ).should == vimeo_expected_params
    end

    it 'generates iframe without height attribute when height is falsy' do
      @story = "http://vimeo.com/20241459"
      embedda = described_class.new(@story, :video_height => false).embed
      expect(embedda).to eq(no_height_embed)
    end
  end

  context "Soundcloud-link" do
    let(:embed_string) { '<iframe width="100%" height="166" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A%2F%2Fsoundcloud.com%2Fflume-1%2Fflume-left-alone-bobby-tank&color=ff6600&amp;auto_play=false&amp;show_artwork=false"></iframe>' }
    let(:link)         { 'https://soundcloud.com/flume-1/flume-left-alone-bobby-tank' }

    it "should embed when text have a link" do
      @story = link
      expect(embedda).to eq(embed_string)
    end

    it "should embed when also other text is present around link" do
      @story = "Hello, my name is Takle: #{link}<br/>And I am embedding links"
      expect(embedda).to eq("Hello, my name is Takle: #{embed_string}<br/>And I am embedding links")
    end

    it "should embed when enabled" do
      @story  = "Hello, my name is Takle: #{link}<br/>And I am embedding links"
      embedda = described_class.new(@story, :filters => :soundcloud).embed
      expect(embedda).to eq("Hello, my name is Takle: #{embed_string}<br/>And I am embedding links")
    end

    it "should not embed when disabled" do
      @story  = "Hello, my name is Takle: #{link}<br/>And I am not embedding links"
      embedda = described_class.new(@story, :filters => :youtube).embed
      expect(embedda).to eq("Hello, my name is Takle: #{link}<br/>And I am not embedding links")
    end
  end

  context "All embeds in one string" do
      let(:youtube)         { '<iframe width="560" height="315" src="http://www.youtube.com/embed/dQw4w9WgXcQ" frameborder="0" allowfullscreen></iframe>' }
      let(:youtube_link)    { 'http://www.youtube.com/watch?v=dQw4w9WgXcQ' }
      let(:vimeo)           { '<iframe src="http://player.vimeo.com/video/20241459" width="560" height="315" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>' }
      let(:vimeo_link)      { 'http://vimeo.com/20241459' }
      let(:soundcloud)      { '<iframe width="100%" height="166" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A%2F%2Fsoundcloud.com%2Fflume-1%2Fflume-left-alone-bobby-tank&color=ff6600&amp;auto_play=false&amp;show_artwork=false"></iframe>' }
      let(:soundcloud_link) { 'https://soundcloud.com/flume-1/flume-left-alone-bobby-tank' }

    it "should show two youtube embeds" do
      @story = "#{youtube_link} #{youtube_link}"
      expect(embedda).to eq("#{youtube} #{youtube}")
    end

    it "should show two vimeo embeds" do
      @story = "#{vimeo_link} #{vimeo_link}"
      expect(embedda).to eq("#{vimeo} #{vimeo}")
    end

    it "should show two soundcloud embeds" do
      @story = "#{soundcloud_link} #{soundcloud_link}"
      expect(embedda).to eq("#{soundcloud} #{soundcloud}")
    end

    it "should show all the embeds in the @story" do
      @story = "#{youtube_link} #{vimeo_link} #{soundcloud_link}"
      expect(embedda).to eq("#{youtube} #{vimeo} #{soundcloud}")
    end
  end

  context "Unkown filter" do
    it "should refuse to embed when unknown filter passed" do
      story = "http://www.youtube.com/watch?v=dQw4w9WgXcQ"
      expect { described_class.new(story, :filters => [:dummy]).embed }.to raise_error(Embedda::UnknownFilter)
    end
  end

  context "Empty string" do
    it "should return empty string" do
      @story = ""
      expect(embedda).to eq("")
    end
  end

end
