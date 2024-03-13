module CommentsHelper
  def formatted_comment_time(comment)
    "Posted #{time_ago_in_words(comment.created_at)} ago"
  end
end
