require_relative '../../../../scrapers/lib/scrapify'

module Rightmove
  class SectionImporter
    def initialize(section:)
      @section = section
      poly = CGI.escape(@section.geojson)
      @url = "https://www.rightmove.co.uk/property-to-rent/find.html?locationIdentifier=USERDEFINEDAREA%5E#{poly}"
    end

    def import
      page = 0
      counts = []
      loop do
        url = page_url(page)

        begin
          index = Scrapify::Http.get(url, encode: false)
          count = scrape_single_index(index)
          counts << count
        rescue Scrapify::Http::BadResponse => e
          break
        end

        break if counts.length >= 5 && counts.count(0) >= 3

        page += 1
        break if page > 41
        sleep 1
      end

      @section.update(lastrun: Date.today)
    end

    def page_url(page_n)
      if @url.include?('?')
        @url + "&index=#{page_n * 24}"
      else
        @url + "?index=#{page_n * 24}"
      end
    end

    def scrape_single_index(index)
      props = index.css('.l-searchResult .propertyCard-priceLink').map { |x| URI.join(@url, x[:href]) }

      added = 0

      props.each do |p|
        next unless p.to_s.include?('/properties/')
        existing = Property.find_by(url: p.to_s)
        if existing && existing.updated_at > 1.week.ago
          Rails.logger.info("Ignoring known property #{p}")
          next
        end

        scrape_property(p)
        added += 1
        sleep 0.5
      end

      added
    end

    def scrape_property(prop_url)
      Rails.logger.info("Scraping #{prop_url}")

      prop = Scrapify::Http.get(prop_url.to_s)

      pm = prop.css('script').map(&:text).find { |x| x.include?('window.PAGE_MODEL') }&.gsub('window.PAGE_MODEL = ', '')
      unless pm
        Rails.logger.error("Page is missing model")
        return
      end

      data = JSON.parse(pm)['propertyData']
      ptype = data['infoReelItems'].find{|x| x['type'] == 'PROPERTY_TYPE'}
      p = Property.upsert({
        section_id: @section.id,
        source: 'rightmove',
        url: prop_url.to_s,
        agency: data['customer'] && data['customer']['companyName'],
        rpm: data['prices']['primaryPrice'].gsub(/[^\d]/, '').to_i,
        bedrooms: data['bedrooms'],
        bathrooms: data['bathrooms'],
        latitude: data['location']['latitude'],
        longitude: data['location']['longitude'],
        description: data['text']['description'],
        images: data['images'].map { |x| x['url'] }.join("\n"),
        plan: data['floorplans'].map { |x| x['url'] }.join("\n"),
        available: parse_lad(data),
        prop_type: ptype && ptype['primaryText'],
        furnish: data['lettings']['furnishType'],
        listing_history: data['lettingHistory'].to_json,
        stations: data['nearestStations'].to_json,
        address: data['address']['displayAddress'],
        key_features: data['keyFeatures'].join("\n"),
        updated_at: Time.now
      }, unique_by: :url)
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
