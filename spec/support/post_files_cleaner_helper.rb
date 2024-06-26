# frozen_string_literal: true

module PostFilesCleanerHelper
  def self.included(base)
    base.around(:each, :create_and_clean_post_files) do |example|
      posts.each do |post|
        StaticPageService.new(post).generate_static_page
      end

      example.run
    ensure
      posts.each do |post|
        StaticPageService.new(post).delete_static_page
      end
    end
  end
end

RSpec.configure do |config|
  config.include PostFilesCleanerHelper
end
