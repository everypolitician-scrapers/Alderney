# frozen_string_literal: true
require 'scraped'
require_relative 'decorators/absolute_urls_from_base'

class MemberPage < Scraped::HTML
  decorator AbsoluteUrlsFromBase

  field :id do
    url[%r{/article/(\d+)/}, 1]
  end

  field :name do
    noko.css('div#contentwrap h1').text.tidy
  end

  field :image do
    noko.css('div.limage img/@src').text
  end

  field :source do
    url
  end
end
