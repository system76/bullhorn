defmodule Bullhorn.Broadway do
  use Broadway
  use Appsignal.Instrumentation.Decorators
  use Spandex.Decorators

  require Logger

  alias Broadway.Message
  alias Bullhorn.{Orders, Users}

  def start_link(_opts) do
    producer_module = Application.fetch_env!(:bullhorn, :producer)

    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: producer_module
      ],
      processors: [
        default: [concurrency: 2]
      ],
      batchers: [
        default: [
          batch_size: 10,
          batch_timeout: 2000
        ]
      ]
    )
  end

  @impl true
  @decorate transaction(:queue)
  @decorate trace()
  def handle_message(_, %Message{data: data} = message, _context) do
    bottle =
      data
      |> URI.decode()
      |> Bottle.Core.V1.Bottle.decode()

    Bottle.RequestId.read(:queue, bottle)

    with {:error, reason} <- notify_handler(bottle.resource) do
      Logger.error(reason)
    end

    message
  end

  @impl true
  def handle_batch(_, messages, _, _) do
    messages
  end

  @impl true
  def handle_failed([failed_message], _context) do
    Appsignal.send_error(%RuntimeError{}, "Failed Broadway Message", [], %{}, nil, fn transaction ->
      Appsignal.Transaction.set_sample_data(transaction, "message", %{data: failed_message.data})
    end)

    [failed_message]
  end

  defp notify_handler({:user_created, message}) do
    Logger.metadata(user_id: message.user.id)
    Logger.info("Handling User Created message")
    Users.created(message)
  end

  defp notify_handler({:password_changed, message}) do
    Logger.metadata(user_id: message.user.id)
    Logger.info("Handling Password Changed message")
    Users.password_changed(message)
  end

  defp notify_handler({:password_reset, message}) do
    Logger.metadata(user_id: message.user.id)
    Logger.info("Handling Password Reset message")
    Users.password_reset(message)
  end

  defp notify_handler({:two_factor_requested, message}) do
    Logger.metadata(user_id: message.user.id)
    Logger.info("Handling Two Factor message")
    Users.two_factor_requested(message)
  end

  defp notify_handler({:recovery_code_used, message}) do
    Logger.metadata(user_id: message.user.id)
    Logger.info("Handling Recovery Code Used message")
    Users.recovery_code_used(message)
  end

  defp notify_handler({:tribble_failed, message}) do
    Logger.metadata(order_id: message.order.id)
    Logger.info("Handling Tribble Failed message")
    Orders.tribble_failed(message)
  end

  defp notify_handler({event, _message}) do
    Logger.warn("Ignoring #{event} message")
    {:ok, :ignored}
  end
end
