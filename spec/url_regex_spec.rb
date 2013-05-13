require "spec_helper"
require "helpers/url_regex"

describe Regex do
  let(:regex) { Regex::URL[:scheme] }

  context "Scheme" do
    let(:scheme) { 'http://' }

    it "should match http://" do
      expect(regex.match(scheme)).to be_true
    end

    it "should match https://" do
      expect(regex.match(scheme)).to be_true
    end
  end

  context "HTTP scheme with mistakes" do
    let(:scheme_typo_1) { 'htttp://' }
    let(:scheme_typo_2) { 'http:://' }
    let(:scheme_typo_3) { 'httpp://' }


    it "should not match typos" do
      expect(regex.match(scheme_typo_1)).to be_false
    end

    it "should not match typos" do
      expect(regex.match(scheme_typo_2)).to be_false
    end

    it "should not match typos" do
      expect(regex.match(scheme_typo_3)).to be_false
    end
  end

  context "Scheme with www." do
    let(:scheme) { 'http://www.' }

    it "should match http://www." do
      expect(regex.match(scheme)).to be_true
    end

    it "should match https://www." do
      expect(regex.match(scheme)).to be_true
    end
  end
end
