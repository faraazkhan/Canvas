module Onelogin::Saml
  class Settings
    
    def initialize(atts={})
      atts.each do |key, val|
        if self.respond_to? "#{key}="
          self.send "#{key}=", val
        end
      end
    end
    
    # The URL at which the SAML assertion should be received.
    attr_accessor :assertion_consumer_service_url
    
    # The name of your application.
    attr_accessor :issuer
    
    # 
    attr_accessor :sp_name_qualifier
    
    # The IdP URL to which the authentication request should be sent.
    attr_accessor :idp_sso_target_url
    
    # The IdP URL to which the logout request should be sent.
    attr_accessor :idp_slo_target_url
    
    # The certificate fingerprint. This is provided from the identity provider when setting up the relationship.
    attr_accessor :idp_cert_fingerprint
    
    # Describes the format of the username required by this application.
    # For email: Onelogin::Saml::NameIdentifiers::EMAIL
    attr_accessor :name_identifier_format
    
    ## Attributes for the metadata
    
    # The logout url of your application
    attr_accessor :sp_slo_url
    
    # The name of the technical contact for your application 
    attr_accessor :tech_contact_name
    
    # The email of the technical contact for your application
    attr_accessor :tech_contact_email
    
    ## Attributes for xml encryption
    
    # The path to the xmlsec1 binary used for xml decryption
    attr_accessor :xmlsec1_path
    
    # The PEM-encoded certificate
    attr_accessor :xmlsec_certificate
    
    # The PEM-encoded private key
    attr_accessor :xmlsec_privatekey
    
    def encryption_configured?
      self.xmlsec1_path && self.xmlsec_certificate && self.xmlsec_privatekey
    end
  end
end