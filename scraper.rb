#!/bin/env ruby
# encoding: utf-8

require 'scraperwiki'
require 'nokogiri'
require 'open-uri'
require 'colorize'

require 'pry'
# require 'open-uri/cached'
# OpenURI::Cache.cache_path = '.cache'
require 'scraped_page_archive/open-uri'

class String
  def tidy
    self.gsub(/[[:space:]]+/, ' ').strip
  end
end

def noko_for(url)
  Nokogiri::HTML(open(url).read)
end

def scrape_list(url)
  noko = noko_for(url)
  noko.xpath('.//ul[@id="leftnavigation"]/li[contains(.,"States Members")]/following-sibling::li[@class="child"]//a/@href').each do |li|
    scrape_mp(li.text)
  end
end

def scrape_mp(url)
  noko = noko_for(url)
    data = { 
      id: url[%r{/article/(\d+)/}, 1],
      name: noko.css('div#contentwrap h1').text.tidy,
      image: noko.css('div.limage img/@src').text,
      district: "Alderney",
      party: "Independent",
      term: 2014,
      source: url,
    }
    # if matched = noko.css('div#contentwrap').text.match(/Elected to Office in (.*?) (20\d\d)/)
      # data[:start_date] = Date.parse("%s-%s-01" % matched.captures.reverse).to_s
    # end
    data[:image] = URI.join(@BASE, URI.escape(data[:image])).to_s unless data[:image].to_s.empty?
    ScraperWiki.save_sqlite([:id, :term], data)
end

@BASE = 'http://www.alderney.gov.gg'
scrape_list('http://www.alderney.gov.gg/article/4077/States-Members')
