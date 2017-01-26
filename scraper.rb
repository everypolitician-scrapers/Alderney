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

def scrape(h)
  url, klass = h.to_a.first
  klass.new(response: Scraped::Request.new(url: url).response)
end

def scrape_list(term, url)
  (scrape url => MembersPage).members.each do |mem_url|
    data = (scrape mem_url => MemberPage).to_h.merge(district: 'Alderney',
                                                     party:    'Independent',
                                                     term:     term)
    ScraperWiki.save_sqlite(%i(id term), data)
  end
end

ScraperWiki.sqliteexecute('DELETE FROM data') rescue nil
scrape_list(2014, 'http://www.alderney.gov.gg/article/4077/States-Members')
