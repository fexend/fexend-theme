# User service class for handling user-related operations

require 'bcrypt'
require 'securerandom'

class UserService
  attr_reader :users

  def initialize
    @users = {}
  end

  # Create a new user
  def create_user(username, email, password)
    # Validate inputs
    return { success: false, error: 'Username already taken' } if user_exists?(username)
    return { success: false, error: 'Email already in use' } if email_exists?(email)
    return { success: false, error: 'Invalid email format' } unless valid_email?(email)
    return { success: false, error: 'Password too short' } if password.length < 8

    # Create user object
    user_id = SecureRandom.uuid
    user = {
      id: user_id,
      username: username,
      email: email,
      password_hash: hash_password(password),
      created_at: Time.now,
      updated_at: Time.now,
      role: 'user',
      active: true
    }

    # Save user
    @users[user_id] = user

    # Return success response
    { success: true, user_id: user_id }
  end

  # Authenticate a user
  def authenticate(username_or_email, password)
    user = find_by_username(username_or_email) || find_by_email(username_or_email)

    if user && verify_password(password, user[:password_hash])
      # Update last login time
      user[:last_login] = Time.now
      { success: true, user_id: user[:id] }
    else
      { success: false, error: 'Invalid username/email or password' }
    end
  end

  # Get user by ID
  def get_user(user_id)
    user = @users[user_id]
    return nil unless user

    # Return user without password hash
    user_data = user.dup
    user_data.delete(:password_hash)
    user_data
  end

  # Update user information
  def update_user(user_id, params = {})
    return { success: false, error: 'User not found' } unless @users[user_id]

    # Don't allow updating certain fields
    params.delete(:id)
    params.delete(:created_at)

    # Handle password update separately
    if params[:password]
      return { success: false, error: 'Password too short' } if params[:password].length < 8
      params[:password_hash] = hash_password(params[:password])
      params.delete(:password)
    end

    # Update the user
    params[:updated_at] = Time.now
    @users[user_id].merge!(params)

    { success: true }
  end

  # Delete a user
  def delete_user(user_id)
    return { success: false, error: 'User not found' } unless @users[user_id]
    @users.delete(user_id)
    { success: true }
  end

  private

  # Check if username exists
  def user_exists?(username)
    @users.values.any? { |user| user[:username].downcase == username.downcase }
  end

  # Check if email exists
  def email_exists?(email)
    @users.values.any? { |user| user[:email].downcase == email.downcase }
  end

  # Find user by username
  def find_by_username(username)
    @users.values.find { |user| user[:username].downcase == username.downcase }
  end

  # Find user by email
  def find_by_email(email)
    @users.values.find { |user| user[:email].downcase == email.downcase }
  end

  # Hash password using BCrypt
  def hash_password(password)
    BCrypt::Password.create(password)
  end

  # Verify password against hash
  def verify_password(password, password_hash)
    BCrypt::Password.new(password_hash) == password
  end

  # Validate email format
  def valid_email?(email)
    email =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  end
end
