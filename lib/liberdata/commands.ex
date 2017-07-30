defmodule Liberdata.Commands do
  defstruct name: nil, docs: nil

  defmacro __using__(_module) do
    quote do
      import Liberdata.Commands
      Module.register_attribute(__MODULE__, :commands, accumulate: true)

      @before_compile Liberdata.Commands
    end
  end

  defmacro cmd(args, rest_var, do: body) do
    quote do
      def apply([unquote_splicing(args) | unquote(rest_var)]) do
        (fn ->
          unquote(body)
        end).()
        |> case do
          {rows, rest} -> apply([rows | rest])
          rows -> apply([rows | unquote(rest_var)])
        end
      end
    end
  end
  defmacro cmd(args, do: body) do
    quote do
      cmd(unquote(args), rest) do
        unquote(body)
      end
    end
  end

  defmacro doc(name, docs) do
    quote do
      @commands %Liberdata.Commands{
        name: unquote(name),
        docs: unquote(docs)
      }
    end
  end

  defmacro __before_compile__(env) do
    html = Module.get_attribute(env.module, :commands)
    |> Enum.map(&format_command/1)
    |> Enum.join("---\n")
    |> Earmark.as_html!

    quote do
      def documentation() do
        unquote(html)
      end

      def apply([rows = %Liberdata.Rows{}]) do
        {:ok, rows}
      end

      def apply(_) do
        {:err, "bad command sequence"}
      end
    end
  end

  def format_command(command) do
    """
    # [`#{command.name}`](##{command.name})
    {: ##{command.name} }

    #{command.docs}
    """
  end
end