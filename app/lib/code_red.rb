class CodeRed
  include HTTParty
  base_uri ENV['API_BASE']
  debug_output

  def initialize
    post_response = self.class.post(
      '/api/login',
      body: {
        username: ENV['API_USER'],
        password: ENV['API_PASS']
      }
    )

    @cookie = post_response.header['Set-Cookie']
  end

  def add_contact(contact)
    contact_response = self.class.post(
      '/api/contacts',
      headers: {
        'Cookie' => @cookie
      },
      body: create_contact_for_post(contact)
    )

    if contact_response.code == 201
      return contact_response["CustomKey"]
    else
      return false
    end
  end

  def contacts()
    contact_response = self.class.get(
      '/api/contacts',
      headers: {
        'Cookie' => @cookie
      }
    )

    if contact_response.code == 200
      puts contact_response.to_yaml
    else
      return false
    end
  end

  private

    def create_contact_for_post(contact)
      created_contact = {
        'CustomKey' => SecureRandom.hex,
        'HomeEmail' => contact.email,
        'FirstName' => contact.first_name,
        'LastName' => contact.last_name,
        'HomePhone' => contact.call ? contact.phone_number : '',
        'TextNumber' => contact.text ? contact.phone_number : '',
        'MobileProvider' => 'Sprint',
        'Zip' => contact.zip,
        'Groups' => ENV['API_GROUPS']
      }

      created_contact
    end
end
