defmodule Budget do

  @path "~/.budget/"
  defp path do
    Path.expand(@path)
  end

  defp filename(name) do
    Path.expand(@path <> name <> ".bud")
  end

  defp init do
    if File.exists?(path()) == false do
      File.mkdir_p(path())
    end
  end

  defp init_file(name) do
    if File.exists?(filename(name)) == false do
      File.touch(filename(name))
    end
  end

  def load(name) do

    init()
    init_file(name)

    case File.read(filename(name)) do
      {:ok, contents} -> contents
      {:error, err} -> err
    end
  end


  def append(name, lines) do
    init()
    init_file(name)
    File.write(filename(name), lines, [:append])
  end

  def add(name, amount, disc \\ "") do
    line = Float.to_string(amount, decimals: 2) <> "\t" <> disc <> "\n";
    append(name, line)
  end

  def print(name, what) do
    init()
    init_file(name)

    {:ok, file} = File.open(filename(name), [:read])

    case what do
      :balence -> IO.puts sum_file(file)
      #:recent  -> 
        _   -> print(name, :balence)
    end

    File.close(file)
  end


  defp sum_file(file, sum \\ 0) do
    case IO.read(file, :line) do
      :eof -> sum
      data -> sum + sum_file(file, extract_sum data)
    end
  end

  defp extract_sum(line) do
    [num | _] = String.split line, "\t", parts: 2

    String.to_float num
  end

  def help do
    IO.puts "Help: 
    COMMANDS:
    $ budget add name amount [details] (eg: $budget add gage 12 \"got paid\")
      'adds an expense to the budget'

    $ budget bal name
      'shows `name`s current balence'

    $ budget log name
      'shows a log of recent expenses from `name`'
      
    $ budget help 
      'shows this help text'
    "
  end

  defp string_to_float(string) do
    {ret, _} = Float.parse(string)
    ret
  end

  defp add_parse(details) do
    case details do
     [name, amount, disc] -> add name, string_to_float(amount), disc
     [name, amount]       -> add name, string_to_float(amount)
     _                    -> IO.puts "Wrong number of arguments, expecting `name amount [description]`"
    end
  end

  defp parse(command, details) do
    command = String.downcase(command)
    case command do
      "help" -> help
      "add"  -> add_parse(details)
      "bal"  -> print(List.first(details), :balence)
      _      -> IO.puts "\"" <> command <> "\" is not a recognized command, type `$ budget help` to get a list of commands"
    end
  end

  def main(args) do
    case args do
      [head | tail] -> parse(head, tail)
      []            -> help
    end     
  end
end
