class User < ActiveRecord::Base
  has_many :comments, dependent: :delete_all
  
  class << self
    def from_omniauth(auth)
      p auth

      provider = auth.provider
      uid = auth.uid
      info = auth.info.symbolize_keys!
      user = User.find_or_initialize_by(uid: uid, provider: provider)
      user.name = info.name
      user.avatar_url = info.image
      if provider == "facebook"
        user.profile_url = "www.facebook.com/app_scoped_user_id/" + uid
      else
        user.profile_url = info.urls.send(provider.capitalize.to_sym)
      end
      user.save!
      user
    end
  end
end
