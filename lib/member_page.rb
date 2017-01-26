# frozen_string_literal: true
require 'scraped'

class MemberPage < Scraped::HTML
  field :id do
    url[%r{/article/(\d+)/}, 1]
  end

  field :name do
    noko.css('div#contentwrap h1').text.tidy
  end

  field :image do
    base = 'http://www.alderney.gov.gg'
    image = noko.css('div.limage img/@src').text
    return image if image.empty?
    URI.join(base, URI.escape(image)).to_s
  end

  field :source do
    url
  end
end
