defmodule Bullhorn.Twilio do
  def deliver_sms_two_factor_token(user, token) do
    ExTwilio.Message.create(
      from: bullhorn_phone_number(),
      body: "System76 Security Code: #{String.upcase(token)}",
      to: user.phone_number
    )
  end

  def deliver_voice_two_factor_token(user, token) do
    spaced_out_token =
      token
      |> String.upcase()
      |> String.split("")
      |> Enum.join(" ")

    twiml = """
    <Response>
      <Say loop="0" voice="woman">
        Hello. Your System76 security code is #{spaced_out_token}.
      </Say>
    </Response>
    """

    ExTwilio.Call.create(
      from: bullhorn_phone_number(),
      to: user.phone_number,
      twiml: twiml
    )
  end

  defp bullhorn_phone_number, do: Application.get_env(:bullhorn, :phone_number)
end
