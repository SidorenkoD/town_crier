class PostsController < ApplicationController
  before_action :set_post

  private

  def set_post
    @post = Post.last || YandexService.new.update_news
  end
end
