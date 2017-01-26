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
    noko.css('div.limage img/@src').text
  end

  field :district do
    'Alderney'
  end

  field :party do
    'Independent'
  end

  field :term do
    2014
  end

  field :source do
    url
  end
end
