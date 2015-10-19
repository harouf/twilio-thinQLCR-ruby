require "twilio_thinqlcr_ruby/version"

module TwilioThinqlcrRuby
  # The main twilio wrapper class that inegrates thinQ.
  class TwilioWrapper

    THINQ_DOMAIN = "wap.thinq.com"
    TWIML_RESOURCE_URL = "http://demo.twilio.com/docs/voice.xml"

    attr_accessor :client, :twilio_account_sid, :twilio_account_token, :thinQ_id, :thinQ_token

    def initialize(twilio_account_sid, twilio_account_token, thinQ_id, thinQ_token)
      @twilio_account_sid = twilio_account_sid
      @twilio_account_token = twilio_account_token
      @thinQ_id = thinQ_id
      @thinQ_token = thinQ_token

      @client = Twilio::REST::Client.new twilio_account_sid, twilio_account_token
    end

    def isClientValid?
        !@client.nil? and !@client.account.nil?
    end

    def call(from, to)
        if !self.isClientValid?
          return "Invalid Twilio Account details."
        end

        begin
          @call = @client.account.calls.create({:to => "sip:#{to}@#{THINQ_DOMAIN}",
                                                :from => from,
                                                :url => TWIML_RESOURCE_URL,
                                                :thinQid => @thinQ_id,
                                                :thinQtoken => @thinQ_token})
          return  @call.sid
        rescue Exception => e
          return e.message
        end
    end

  end
end
