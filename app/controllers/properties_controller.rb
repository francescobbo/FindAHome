class PropertiesController < ApplicationController
  def index
    page = params[:page]&.to_i || 1 - 1
    @properties = Property.where(hidden_at: nil, star: false).order(rpm: :desc)

    filter_properties

    @paged_properties = @properties.offset(100 * page).limit(100)
  end

  def starred
    @properties = Property.where(hidden_at: nil, star: true).order(rpm: :asc)
  end

  def heatmap
    @rooms = params[:rooms].to_i

    @sections = Section.all

    @prop = Property.where(hidden_at: nil)
    @prop = @prop.where("bedrooms <= ?", params[:max_beds]) if params[:max_beds]
    @prop = @prop.where("rpm <= ?", params[:max_rpm]) if params[:max_rpm]

    @avg = @prop.average(:rpm).to_f
    @stddev = @prop.stddev(@avg)
  end

  def median_zscore(m)
    (m - @avg) / @stddev
  end

  helper_method :median_color
  def median_color(m)
    return '' unless m
    z = median_zscore(m)
    z = z < -2 ? -2 : (z > 2 ? 2 : z)
    f = (z + 2) / 4.0
    "rgb(" + [f * 255, (1.0 - f) * 255, 0].join(', ') + ")"
  end

  def kill
    Property.find(params[:id]).update(hidden_at: Time.now)
  end

  def star
    Property.find(params[:id]).update(star: true)
  end
end
