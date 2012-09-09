module Starter

  module HTTP

    def self.basic_auth(user, pass)
      # TODO: I wrote a clearer version of this somewhere.  Find and replace.
			"Basic #{["#{user}:#{pass}"].pack('m').delete("\r\n")}"
    end

  end

end
