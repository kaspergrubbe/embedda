require 'spec_helper'
require 'embedda/core_ext'

describe String do
  it 'should have #embedda method' do
    expect(described_class.new).to respond_to(:embedda)
  end

  context '#embedda' do
    let(:embed_string) { '<iframe width="560" height="315" src="http://www.youtube.com/embed/dQw4w9WgXcQ" frameborder="0" allowfullscreen></iframe>' }
    let(:media_link)   { 'http://www.youtube.com/watch?v=dQw4w9WgXcQ' }

    it 'should embed media' do
      expect(media_link.embedda).to eq(embed_string)
    end
  end
end

