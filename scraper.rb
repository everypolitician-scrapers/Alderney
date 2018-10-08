#!/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require 'pry'
require 'require_all'
require 'scraped'
require 'scraperwiki'

require_rel 'lib'

require 'open-uri/cached'
OpenURI::Cache.cache_path = '.cache'

def scrape(h)
  url, klass = h.to_a.first
  klass.new(response: Scraped::Request.new(url: url).response)
end

ScraperWiki.sqliteexecute('DELETE FROM data') rescue nil

url = 'http://www.alderney.gov.gg/article/4077/States-Members'
data = (scrape url => MembersPage).member_urls.map do |mem_url|
  (scrape mem_url => MemberPage).to_h.merge(district: 'Alderney',
                                            party:    'Independent')
end

# data.each { |d| puts d.reject { |_k, v| v.to_s.empty? }.sort_by { |k, _v| k }.to_h }
ScraperWiki.save_sqlite(%i(id), data)
