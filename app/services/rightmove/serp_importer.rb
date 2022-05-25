require_relative '../../../../scrapers/lib/scrapify'

module Rightmove
  class SerpImporter
    def initialize(url:)
      @url = url
    end

    def import
      page = 0
      loop do
        url = page_url(page)

        begin
          index = Scrapify::Http.get(url, encode: false)
          scrape_single_index(index)
        rescue Scrapify::Http::BadResponse => e
          break
        end

        page += 1
        break if page > 41
        sleep 1
      end
    end

    def page_url(page_n)
      return @url if page_n.zero?

      if @url.include?('?')
        @url + "&index=#{page_n * 24}"
      else
        @url + "?index=#{page_n * 24}"
      end
    end

    def scrape_single_index(index)
      props = index.css('.l-searchResult .propertyCard-priceLink').map { |x| URI.join(@url, x[:href]) }

      props.each do |p|
        next unless p.to_s.include?('/properties/')
        if Property.exists?(url: p.to_s)
          Rails.logger.info("Ignoring known property #{p}")
          next
        end

        scrape_property(p)
        sleep 0.5
      end
    end

    def scrape_property(prop_url)
      Rails.logger.info("Scraping #{prop_url}")

      prop = Scrapify::Http.get(prop_url.to_s)

      pm = prop.css('script').map(&:text).find { |x| x.include?('window.PAGE_MODEL') }&.gsub('window.PAGE_MODEL = ', '')
      raise "Page is missing model" unless pm

      data = JSON.parse(pm)['propertyData']
      ptype = data['infoReelItems'].find{|x| x['type'] == 'PROPERTY_TYPE'}

      Property.create(
        source: 'rightmove',
        url: prop_url.to_s,
        agency: data['customer'] && data['customer']['companyName'],
        rpm: data['prices']['primaryPrice'].gsub(/[^\d]/, '').to_i,
        bedrooms: data['bedrooms'],
        bathrooms: data['bathrooms'],
        latitude: data['location']['latitude'],
        longitude: data['location']['longitude'],
        ups: 0,
        downs: 0,
        description: data['text']['description'],
        images: data['images'].map { |x| x['url'] }.join("\n"),
        plan: data['floorplans'].map { |x| x['url'] }.join("\n"),
        available: parse_lad(data),
        prop_type: ptype && ptype['primaryText'],
        furnish: data['lettings']['furnishType'],
        listing_history: data['lettingHistory'].to_json,
        stations: data['nearestStations'].to_json,
        address: data['address']['displayAddress'],
        key_features: data['keyFeatures'].join("\n")
      )
    end

    def parse_lad(data)
      v = data['lettings']['letAvailableDate']
      if v == nil || v == 'Now'
        nil
      else
        Date.parse(v)
      end

    rescue nil
    end
  end
end
