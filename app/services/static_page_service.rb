class StaticPageService
  def self.generate_static_page_from_post(post)
    file_path = get_file_path(post.static_page_name)

    File.open(file_path, 'w') do |file|
      file.write(generate_page(post))
    end
  end

  def self.delete_static_page(static_page_name)
    file_path = get_file_path(static_page_name)
    File.delete(file_path) if File.exist?(file_path)
  end

  def self.static_page_exist?(static_page_name)
    File.exist?(get_file_path(static_page_name))
  end

  private

  def self.get_file_path(static_page_name)
    Rails.root.join("app/views/posts/static_pages/#{static_page_name}.html.erb")
  end

  def self.generate_page(post)
    <<-HTML
    <h1>#{post.title}</h1>
    <p>#{post.body}</p>
    <p>#{post.video_url}</p>
    <p>#{post.user}</p>
    HTML
  end
end
