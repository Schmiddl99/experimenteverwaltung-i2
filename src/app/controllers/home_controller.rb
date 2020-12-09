class HomeController < ApplicationController
  def landing_page
    @cover_picture = CoverPicture.find_by(current: true).try(:file).try(:url, :original)
  end
end
