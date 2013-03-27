class SendActivationLinkWorker
	#@queue = :send_activation_link
  include Sidekiq::Worker
  sidekiq_options :retry => false

	def perform(user_id)
		user = User.find(user_id)
	    key = SecureRandom.uuid.first(8)
	    digest = Digest::SHA1.hexdigest("#{user_id}#{key}#{ACTIVATION_KEY}")
	    MailUser.send_activation_link(user, key, digest).deliver
	end
end