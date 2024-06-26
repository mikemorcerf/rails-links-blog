# frozen_string_literal: true

class StaticPageService
  def initialize(post)
    @post = post
    @static_page_name = post&.static_page_name
    @file_path = file_path
  end

  def generate_static_page
    File.open(@file_path, 'w') do |file|
      file.write(generate_page)
    end
  end

  def delete_static_page
    File.delete(@file_path) if static_page_exist?
  end

  def static_page_exist?
    File.exist?(@file_path)
  end

  private

  def file_path
    Rails.root.join("app/views/posts/static_pages/#{@static_page_name}.html.erb")
  end

  def generate_page
    ApplicationController.render(
      template: 'posts/static_page',
      layout: true,
      locals: { post: @post }
    )
  end
end
