defmodule ExampleApi.Middleware.ErrorHandler do
  @moduledoc false
  @behaviour Absinthe.Middleware

  alias ExampleApi.Error

  @impl true
  def call(%{errors: errors} = resolution, _config) do
    errors =
      errors
      |> Enum.map(&Error.normalize/1)
      |> List.flatten()
      |> Enum.map(&to_absinthe_format/1)

    %{resolution | errors: errors}
  end

  defp to_absinthe_format(%Error{} = error), do: Map.from_struct(error)
  defp to_absinthe_format(error), do: error
end
