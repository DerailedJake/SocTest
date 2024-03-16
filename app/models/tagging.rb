class Tagging < ApplicationRecord
  belongs_to :taggable, polymorphic: true
  belongs_to :tag, counter_cache: :taggable_count
end
