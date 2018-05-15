defmodule Foretoken.Application do
  use Application

  @impl true
  def start(_type, _args) do
    Foretoken.Ets.init()
    children = [
      Foretoken.InactiveBucketCleaner,
    ]
    Supervisor.start_link(children, [strategy: :one_for_one])
  end
end
