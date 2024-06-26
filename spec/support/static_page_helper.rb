# frozen_string_literal: true

module StaticPageHelper
  def delete_static_page_by_name(static_page_name)
    file_path = Rails.root.join("app/views/posts/static_pages/#{static_page_name}.html.erb")
    FileUtils.rm_f(file_path)
  end
end

RSpec.configure do |config|
  config.include StaticPageHelper
end
