defmodule Bullhorn.UsersTest do
  use ExUnit.Case
  use Bamboo.Test

  alias Bottle.Account.V1.User
  alias Bottle.Account.V1.{PasswordChanged, PasswordReset, UserCreated}
  alias Bullhorn.Users

  describe "created/1" do
    test "sends a welcome email for Welcome message types" do
      user = User.new(email: "test@example.com", first_name: "Test", last_name: "User")
      Users.created(UserCreated.new(user: user))
      assert_email_delivered_with(to: [{"Test User", user.email}], subject: "Welcome to the System76 community!")
    end
  end

  describe "password_reset/1" do
    test "sends a password reset for PasswordReset message types" do
      user = User.new(email: "test@example.com", first_name: "Test", last_name: "User")
      Users.password_reset(PasswordReset.new(user: user, reset_key: "ABC123"))
      assert_email_delivered_with(to: [{"Test User", user.email}], subject: "Recover your System76 account")
    end
  end

  describe "password_changed/1" do
    test "sends a password changed notification for PasswordChanged message types" do
      user = User.new(email: "test@example.com", first_name: "Test", last_name: "User")
      Users.password_changed(PasswordChanged.new(user: user))
      assert_email_delivered_with(to: [{"Test User", user.email}], subject: "Your System76 password has been updated")
    end
  end
end
