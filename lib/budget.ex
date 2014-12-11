
defmodule Budget do
  @moduledoc """
  #Budget 
  This is a module that handles interacting with the file system of
  the budgeting application. 
  """

  # Private --------

  @path "~/.budget/"
  defp path do
    Path.expand(@path)
  end

  defp filename(name) do
    name = name 
            |> String.downcase 
            |> String.replace(" ","-")

    Path.expand(@path <> name <> "")
  end

  defp init do
    if File.exists?(path()) == false do
      File.mkdir_p(path())
    end
  end

  defp init_file(name) do
    name = filename(name)

    if File.exists?(name) == false do
      File.touch(name)
    end
  end

  defp sum_file(name) do
    load(name) 
    |> Enum.map(&extract_amount/1)
    |> List.foldr(0.0, &+/2)
  end


  # This will extract all the info from a date
  defp extract_line(line) do
    use Timex

    [amount, date, disc] = String.split line, "|"

    amount = String.to_float(amount)

    {:ok, date} = DateFormat.parse(date, "%Y-%m-%d", :strftime)

    {amount, date, disc}
  end

  defp extract_amount(line) do
    {amount, _, _} = line

    amount
  end


  defp append(name, lines) do
    init()
    init_file(name)
    File.write(filename(name), lines, [:append])
  end


  defp print_sum(name) do
    amount = sum_file(name) |> Float.to_string(decimals: 2)
    mess = name <> " has $" <> amount
    IO.puts(mess)
  end

  # Public ------

  @doc """
  Will add an amount of money to a budget
  """
  def add(name, amount, disc \\ "") do
    use Timex
    date = DateFormat.format!(Date.now, "%Y-%m-%d", :strftime)
    line = Float.to_string(amount, decimals: 2) <> "|" <> date <> "|" <> disc <> "\n";
    append(name, line)
    print(name, :balence)
  end


  @doc """
  This will remove an amount of money from a budget
  """
  def remove(name, amount, disc \\ "") do
    add(name, -amount, disc)
  end

  def log(name, amount) do
    load(name) |> Enum.reverse |> Enum.take(amount)
  end


  @doc """
  This will print out various things about the budget
  """
  def print(name, what) do
    init()
    init_file(name)

    case what do
      :balence -> print_sum(name)
      :log     -> print_log(name, 10)
      _        -> print(name, :balence)
    end
  end


  defp print_log(name, num) do
    log(name, num)
    |> List.foldr("\n", &<>/2)
    |> String.replace("|", "\t", global: true)
    |> IO.puts
  end

  @doc """
  Will list the names of budgets available
  todo:
  - Make this more general
  """
  def list do
    IO.puts "Here's a list of budgets:"
    {:ok, files}= File.ls(path())
    str = files 
          |> Enum.map(fn(item) -> " - " <> item <> "\n" end)
          |> List.foldr("", &<>/2)
  end 

  @doc """
  This will load the information from the file
  """
  def load(name) do
    init()
    init_file(name)

    if File.exists? filename(name) do
      filename(name) 
      |> File.stream!
      |> Enum.to_list
      |> Enum.map &extract_line/1
    end
  end

end
