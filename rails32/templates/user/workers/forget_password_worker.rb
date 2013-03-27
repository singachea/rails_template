class ForgetPasswordWorker 
	#@queue = :forget_password
  include Sidekiq::Worker
  sidekiq_options :retry => false

	def perform(user_id)
	    user = User.find(user_id)
	    expired = (Time.now + 1.day).to_i
	    digest = Digest::SHA1.hexdigest("#{expired}#{user.password_recoverable}")
	    new_password = Digest::SHA1.hexdigest(digest).first(8)

	    MailUser.forget_password(user, expired, digest, new_password).deliver
	end
end