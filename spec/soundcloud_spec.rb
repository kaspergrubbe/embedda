require "spec_helper"
require "embedda"

describe Embedda do
  let(:embedda) { described_class.new(@story).embed }

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

  context "Soundcloud-sets-link" do
    let(:embed_string) { '<iframe width="100%" height="166" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A%2F%2Fsoundcloud.com%2Ftekktv%2Fsets%2Fdj-mix-sets&color=ff6600&amp;auto_play=false&amp;show_artwork=false"></iframe>' }
    let(:link)         { 'https://soundcloud.com/tekktv/sets/dj-mix-sets' }

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
end
