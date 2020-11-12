defmodule Bullhorn.Broadway do
  use Broadway
  use Appsignal.Instrumentation.Decorators

  require Logger

  alias Broadway.Message
  alias Bottle.Core.V1.Bottle

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
  def handle_message(_, %Message{data: data} = message, _context) do
    %{resource: resource, request_id: request_id} =
      data
      |> URI.decode()
      |> Bottle.decode()

    Logger.metadata(request_id: request_id)

    notify_handler(resource)

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
  end

  defp notify_handler(%mod{} = message) do
    {handler, _messages} =
      Enum.find(message_handlers(), fn {_handler, messages} ->
        mod in messages
      end)

    case handler do
      nil ->
        Logger.debug("Ignored #{mod} message")

      mod ->
        Logger.debug("Handling #{mod} message")
        apply(mod, :handle_message, [message])
    end
  end

  defp message_handlers, do: Application.get_env(:bullhorn, :message_handlers)
end
