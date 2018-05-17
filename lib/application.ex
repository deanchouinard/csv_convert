defmodule CSVConvert.Application do

  def start(_type, _args) do
    Task.async(fn -> CSVConvert.convert end) |> Task.await
    Supervisor.start_link([], strategy: :one_for_one)

    # Use a Supervisor

    # children = [
    #   {Task, fn -> CSVConvert.convert end}
    # ]
    #
    # opts = [strategy: :one_for_one, name: CSVConvert.Supervisor]
    # Supervisor.start_link(children, opts)
  end
end

