# frozen_string_literal: true
require_relative './test_helper'
require_relative '../lib/member_page.rb'

describe MemberPage do
  around { |test| VCR.use_cassette(File.basename(url), &test) }

  subject do
    MemberPage.new(response: Scraped::Request.new(url: url).response)
  end

  describe 'Page with image' do
    let(:url) { 'http://www.alderney.gov.gg/article/4081/Ian-Tugby' }

    it 'should return the expected data' do
      subject.to_h.must_equal(
        id:     '4081',
        name:   'Ian Tugby',
        image:  'http://www.alderney.gov.gg/media/image/6/o/140913_Alderney-801.jpg',
        source: url
      )
    end
  end

  describe 'Page without image' do
    let(:url) { 'http://www.alderney.gov.gg/article/157566/Mike-Dean' }

    it 'should return the expected data' do
      subject.to_h.must_equal(
        id:     '157566',
        name:   'Mike Dean',
        image:  '',
        source: url
      )
    end
  end
end
