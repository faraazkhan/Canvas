module Onelogin::Saml
  class MetaData
    def self.create(settings)
      xml = %{<?xml version="1.0"?>
        <EntityDescriptor xmlns="urn:oasis:names:tc:SAML:2.0:metadata" entityID="#{settings.issuer}">
          <SPSSODescriptor protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol">
      }
      if settings.encryption_configured?
        xml += %{
            <KeyDescriptor use="encryption">
              <KeyInfo xmlns="http://www.w3.org/2000/09/xmldsig#">
                <X509Data>
                  <X509Certificate>
                    #{File.read(settings.xmlsec_certificate).gsub(/\w*-+(BEGIN|END) CERTIFICATE-+\w*/, "").strip}
                  </X509Certificate>
                </X509Data>
              </KeyInfo>
              <EncryptionMethod Algorithm="http://www.w3.org/2001/04/xmlenc#aes128-cbc">
                <KeySize xmlns="http://www.w3.org/2001/04/xmlenc#">128</KeySize>
              </EncryptionMethod>
            </KeyDescriptor>
        }
      end
      xml += %{
            <SingleLogoutService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect" Location="#{settings.sp_slo_url}"/>
            <AssertionConsumerService index="0" Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" Location="#{settings.assertion_consumer_service_url}"/>
          </SPSSODescriptor>
          <ContactPerson contactType="technical">
            <SurName>#{settings.tech_contact_name}</SurName>
            <EmailAddress>mailto:#{settings.tech_contact_email}</EmailAddress>
          </ContactPerson>
        </EntityDescriptor>
      }
      xml
    end
  end
end
