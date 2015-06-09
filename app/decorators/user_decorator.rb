# coding: utf-8
module UserDecorator
  def gravatar
    gravatar_id = Digest::MD5::hexdigest(self.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: self.username)
  end
end
