#!/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require 'pry'
require 'require_all'
require 'scraped'
require 'scraperwiki'

require_rel 'lib'

# require 'open-uri/cached'
# OpenURI::Cache.cache_path = '.cache'
require 'scraped_page_archive/open-uri'

def noko_for(url)
  Nokogiri::HTML(open(url).read)
end

def scrape(h)
  url, klass = h.to_a.first
  klass.new(response: Scraped::Request.new(url: url).response)
end

def scrape_list(url)
  noko = noko_for(url)
  (scrape url => MembersPage).members.each do |mem_url|
    scrape_mp(mem_url)
  end
end

def scrape_mp(url)
  noko = noko_for(url)
  data = {
    id:       url[%r{/article/(\d+)/}, 1],
    name:     noko.css('div#contentwrap h1').text.tidy,
    image:    noko.css('div.limage img/@src').text,
    district: 'Alderney',
    party:    'Independent',
    term:     2014,
    source:   url,
  }
  # if matched = noko.css('div#contentwrap').text.match(/Elected to Office in (.*?) (20\d\d)/)
  # data[:start_date] = Date.parse("%s-%s-01" % matched.captures.reverse).to_s
  # end
  data[:image] = URI.join(@BASE, URI.escape(data[:image])).to_s unless data[:image].to_s.empty?
  ScraperWiki.save_sqlite(%i(id term), data)
end

@BASE = 'http://www.alderney.gov.gg'

ScraperWiki.sqliteexecute('DELETE FROM data') rescue nil
scrape_list('http://www.alderney.gov.gg/article/4077/States-Members')
