# frozen_string_literal: true

module PostFilesCleanerHelper
  def self.included(base)
    base.around(:each, :create_and_clean_post_files) do |example|
      begin
        posts.each do |post|
          StaticPageService.generate_static_page_from_post(post)
        end

        example.run
      ensure
        posts.each do |post|
          StaticPageService.delete_static_page(post.static_page_name)
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include PostFilesCleanerHelper
end
