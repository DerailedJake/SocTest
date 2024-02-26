module StoriesHelper
  def day_created(post)
    post.created_at.strftime('%d %B %Y')
  end

  def hour_created(post)
    post.created_at.strftime('%H:%M')
  end
end
