class ApplicationController < ActionController::Base
  def filter_properties
    if params[:min_rpm]
      @properties = @properties.where("rpm >= ?", params[:min_rpm])
    end

    if params[:max_rpm]
      @properties = @properties.where("rpm <= ?", params[:max_rpm])
    end

    if params[:max_beds]
      @properties = @properties.where("bedrooms <= ?", params[:max_beds])
    end

    if params[:min_beds]
      @properties = @properties.where("bedrooms >= ?", params[:min_beds])
    end

    if params[:search]
      @properties = @properties.where("LOWER(key_features) LIKE ? OR LOWER(description) LIKE ?", "%#{params[:search].downcase}%", "%#{params[:search].downcase}%")
    end
  end
end
