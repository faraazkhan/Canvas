module Onelogin::Saml
  class AuthRequest
    def self.create(settings)
      id                = Onelogin::Saml::AuthRequest.generate_unique_id(42)
      issue_instant     = Onelogin::Saml::AuthRequest.get_timestamp

      request = 
        "<samlp:AuthnRequest xmlns:samlp=\"urn:oasis:names:tc:SAML:2.0:protocol\" ID=\"#{id}\" Version=\"2.0\" IssueInstant=\"#{issue_instant}\" ProtocolBinding=\"urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST\" AssertionConsumerServiceURL=\"#{settings.assertion_consumer_service_url}\">" +
        "<saml:Issuer xmlns:saml=\"urn:oasis:names:tc:SAML:2.0:assertion\">#{settings.issuer}</saml:Issuer>\n" +
        "<samlp:NameIDPolicy xmlns:samlp=\"urn:oasis:names:tc:SAML:2.0:protocol\" Format=\"#{settings.name_identifier_format}\" AllowCreate=\"true\"></samlp:NameIDPolicy>\n" +
        "<samlp:RequestedAuthnContext xmlns:samlp=\"urn:oasis:names:tc:SAML:2.0:protocol\" Comparison=\"exact\">" +
        "<saml:AuthnContextClassRef xmlns:saml=\"urn:oasis:names:tc:SAML:2.0:assertion\">urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport</saml:AuthnContextClassRef></samlp:RequestedAuthnContext>\n" +
        "</samlp:AuthnRequest>"

      deflated_request  = Zlib::Deflate.deflate(request, 9)[2..-5]     
      base64_request    = Base64.encode64(deflated_request)  
      encoded_request   = CGI.escape(base64_request)  
  
      settings.idp_sso_target_url + "?SAMLRequest=" + encoded_request
    end
    
    private 
    
    def self.generate_unique_id(length)
      chars = ("a".."f").to_a + ("0".."9").to_a
      chars_len = chars.size
      unique_id = ""
      1.upto(length) { |i| unique_id << chars[rand(chars_len-1)] }
      unique_id
    end
    
    def self.get_timestamp
      Time.new.utc.strftime("%Y-%m-%dT%H:%M:%SZ")
    end
  end
end
