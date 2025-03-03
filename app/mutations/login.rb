# app/graphql/mutations/login_user.rb
module Mutations
  class LoginUser < BaseMutation
    # Input arguments for the mutation
    argument :username, String, required: true
    argument :password, String, required: true

    # Output fields for the mutation
    field :token, String, null: true
    field :errors, [String], null: true

    def resolve(username:, password:)
      user = User.find_by(username: username)
      
      # Vulnerable part: Different error messages expose whether the username exists.
      if user.nil?
        # This message reveals that the username does not exist.
        return { token: nil, errors: ["User with username '#{username}' not found."] }
      end

      unless user.authenticate(password)
        # This message confirms that the username exists but the password is wrong.
        return { token: nil, errors: ["Incorrect password for user '#{username}'."] }
      end

      # If credentials are correct, generate a fake token for demonstration.
      token = generate_jwt(user)
      { token: token, errors: [] }
    end

    private

    def generate_jwt(user)
      # Fake token generation for demonstration purposes.
      "fake-jwt-token-for-user-#{user.id}"
    end
  end
end
