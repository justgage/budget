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

  @doc """
  Will add an ammount to a budget, use negitive numbers for taking away
  """
  def add(name, amount, disc \\ "") do
    use Timex
    date = DateFormat.format!(Date.now, "%Y-%m-%d", :strftime)
    line = Float.to_string(amount, decimals: 2) <> "\t" <> disc <> "\t" <> date <> "\n";
    append(name, line)
    print(name, :balence)
  end


  @doc """
  This will print out various things about the budget
  """
  def print(name, what) do
    init()
    init_file(name)

    {:ok, file} = File.open(filename(name), [:read])

    case what do
      :balence -> IO.puts(name <> " has $" <> sum_file(file))
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

end
