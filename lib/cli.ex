

defmodule Cli do
   @moduledoc """
   #Cli 
   This is the command line interface for Budget, or 'cli'
   """
  require Budget

  defp string_to_float(string) do
    {ret, _} = Float.parse(string)
    ret
  end


  defp add_parse(details) do
    case details do
     [name, amount, disc] -> Budget.add name, string_to_float(amount), disc
     [name, amount]       -> Budget.add name, string_to_float(amount)
     _                    -> IO.puts "Wrong number of arguments, expecting `name amount [description]`"
    end
  end

  defp parse(command, details) do
    command = String.downcase(command)
    helptext = "\"" <> command <> "\" is not a recognized command, type `$ budget help` to get a list of commands"
    case command do
      "help" -> help
      "add"  -> add_parse(details)
      "bal"  -> Budget.print(List.first(details), :balence)
      _      -> IO.puts helptext
    end
  end

  @doc """
  Displays help
  """
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

  @doc """
  Starts the whole thing rolling!
  """
  def main(args) do
    case args do
      [head | tail] -> parse(head, tail)
      []            -> help
    end     
  end
end
