defmodule CSVConvert do
  @moduledoc """
  Documentation for CSVConvert.
  """

  @doc """
  Hello world.

  ## Examples

      iex> CSVConvert.hello
      :world

  """
  def hello do
    :world
  end
  
  def start(_type, _args) do
    file_name = "ExportData.csv"
    IO.puts file_name
    file_data = file_name
    |> get_raw_data
    |> Enum.reject(&filter_hidden/1)
    |> Enum.map(&convert_keys/1)
    #    |> CSV.encode
    #|> Enum.to_string()
    |> IO.inspect
    |> tocsv
    #
    #File.write!("out.txt", file_data )
    # |> Enum.map(&convert_body/1)
    # |> Enum.map(&send_email/1)

    Supervisor.start_link [], strategy: :one_for_one
  end

  defp get_raw_data(file_name) do
    file_name
    |> File.open!([:utf8])
    # |> IO.inspect
    |> IO.stream(:line)
    |> CSV.decode(headers: true)
    # |> IO.inspect
  end

  defp convert_keys(record) do
    #    IO.inspect record, label: "data record"

    %{"EMAIL ADDRESS" => email, "FIRST NAME" => fname,
        "LAST NAME" => lname} = record
        # IO.puts email
    %{"EMAIL_ADDRESS" => email, "NAME" => fname <> " " <> lname}
  end

  defp filter_hidden(record) do
    %{"HIDDEN FROM ADDRESS LIST" => hidden} = record
    hidden == "TRUE"
  end
  
  defp tocsv(map) do
      File.open("out.csv", [:write, :utf8], fn(file) ->
        Enum.each(map, &IO.write(file, make_line(&1) <> "\n")) end)
  end

  defp make_line(map) do
    IO.inspect map
    %{ "EMAIL_ADDRESS" => email, "NAME" => name} = map
    #    \" <> email <> \" <> " , " <> name
    ~s("#{email}", "#{name}")
  end

end
