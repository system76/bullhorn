defmodule Bullhorn.UsersTest do
  use ExUnit.Case
  use Bamboo.Test

  alias Bottle.Account.V1.User
  alias Bottle.Notification.User.V1.{Created, PasswordChanged, PasswordReset}
  alias Bullhorn.Users

  describe "handle_message/1" do
    setup do
      user = User.new(email: "test@example.com", first_name: "Test", last_name: "User")

      {:ok, user: user}
    end

    test "sends a welcome email for Welcome message types", %{user: user} do
      Users.handle_message(%Created{user: user})
      assert_email_delivered_with(to: [{"Test User", user.email}], subject: "Welcome to the System76 community!")
    end

    test "sends a password reset for PasswordReset message types", %{user: user} do
      Users.handle_message(%PasswordReset{user: user, reset_key: "ABC123"})
      assert_email_delivered_with(to: [{"Test User", user.email}], subject: "Recover your System76 account")
    end

    test "sends a password changed notification for PasswordChanged message types", %{user: user} do
      Users.handle_message(%PasswordChanged{user: user})
      assert_email_delivered_with(to: [{"Test User", user.email}], subject: "Your System76 password has been updated")
    end
  end
end
