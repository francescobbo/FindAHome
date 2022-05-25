class Property < ApplicationRecord
  default_scope -> { where.not(prop_type: ['House Share', 'Flat Share']) }
  belongs_to :section

  def self.sane(bedrooms)
    where(bedrooms: bedrooms).where("rpm > ? AND rpm < ?", 200 * bedrooms, 3000 * bedrooms)
  end

  def self.stddev(avg)
    Math.sqrt(select("AVG((rpm - #{avg}) * (rpm - #{avg})) as stddev")[0]['stddev'] || 0)
  end
end
