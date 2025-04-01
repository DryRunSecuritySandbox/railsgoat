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
        
        if user.nil?
          return { token: nil, errors: ["User with username '#{username}' not found."] }
        end
  
        unless user.authenticate(password)
          return { token: nil, errors: ["Incorrect password for user '#{username}'."] }
        end
  
        token = generate_jwt(user)
        { token: token, errors: [] }
      end
  
      private
  
      def generate_jwt(user)
        "fake-jwt-token-for-user-#{user.id}"
      end
    end
  end
