class SectionsController < ApplicationController
  def show
    @section = Section.find(params[:id])
    @starred_properties = @section.properties.where(star: true)
    @properties = @section.properties.where(hidden_at: nil, star: false).order(rpm: :desc)

    filter_properties
  end

  def scan_now
    section = Section.find(params[:id])
    Rightmove::SectionImporter.new(section: section).import

    redirect_to section_path(section)
  end

  def disable
    section = Section.find(params[:id])
    section.update!(consider: false)
    section.properties.delete_all
    redirect_to '/heatmap/1'
  end

  def enable
    section = Section.find(params[:id])
    section.update!(consider: true)
    redirect_to '/heatmap/1'
  end
end