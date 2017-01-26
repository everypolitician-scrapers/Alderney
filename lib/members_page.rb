# frozen_string_literal: true
require 'scraped'

class MembersPage < Scraped::HTML
  field :members do
    noko.xpath('.//ul[@id="leftnavigation"]/li[contains(.,"States Members")]/following-sibling::li[@class="child"]//a/@href')
        .map(&:text)
  end
end
