class Section < ApplicationRecord
  has_many :properties

  def median_price(max_beds: nil, max_rpm: nil)
    all = properties
    all = all.where("bedrooms <= ?", max_beds) if max_beds
    all = all.where("rpm <= ?", max_rpm) if max_rpm
    all.where(hidden_at: nil).average(:rpm)
  end

  def center
    d = JSON.parse(data)
    v = [
      d[0][0] - 0.0025,
      d[0][1] + 0.005
    ]
    v.to_json
  end

  def contains?(lng, lat)
    square = JSON.parse(data)
    lat <= square[0][0] && lat >= square[1][0] && lng >= square[0][1] && lng <= square[2][1]
  end

  def near?(lng, lat)
    square = JSON.parse(data)
    lat_cnt = square[0][0] - (square[0][0] - square[1][0]) / 2
    lng_cnt = square[0][1] + (-square[0][1] + square[2][1]) / 2
    Math.sqrt((lat - lat_cnt) ** 2 + (lng - lng_cnt) ** 2) < 1/111.0
  end
end
