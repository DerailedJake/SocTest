class NotificationManager < ApplicationRecord
  belongs_to :user
  has_many :notifications
  before_create :default_data

  def settings
    JSON.parse(settings_data)
  end

  def reset_settings
    update(settings_data: default_data)
  end

  def settings_data_from_params(params)
    fields = settings_fields
    data = fields.map{ |e| [e, false] }.to_h
    params.each_key do |key|
      next unless fields.include?(key)
      data[key] = true
    end
    self.settings_data = data.to_json
  end

  private

  def default_data
    self.settings_data = settings_fields.map{|e| [e, true]}.to_h.to_json
  end

  def settings_fields
    %w[story_commented story_liked post_commented post_liked comments_liked observed_stories observed_posts]
  end
end
