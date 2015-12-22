class Comment < ActiveRecord::Base
  belongs_to :user
  validates :body, presence: true, length: { maximum: 2000 }
  after_create :notify_comment_added

  class << self
    def on_change
      Comment.connection.execute "LISTEN comments"
      loop do
        Comment.connection.raw_connection.wait_for_notify do |event, pid, comment|
          yield comment
        end
      end
    ensure
      Comment.connection.execute "UNLISTEN comments"
    end

    def remove_excessive!
      if all.count > 100
        order('created_at ASC').limit(all.count - 50).destroy_all
      end
    end
  end

  def timestamp
    created_at.strftime('%-d %B %Y, %H:%M:%S')
  end

  def basic_info_json
    JSON.generate({ user_name: user.name, user_avatar: user.avatar_url, user_profile: user.profile_url,
      body: body, timestamp: timestamp})
  end

  private

  def notify_comment_added
    # Comment.connection.execute "NOTIFY comments, '#{self.basic_info_json}'"
    Comment.connection.execute "NOTIFY comments, '#{self.id}'"
  end
end
