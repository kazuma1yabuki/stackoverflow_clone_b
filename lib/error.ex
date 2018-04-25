use Croma

defmodule StackoverflowCloneB.Error do
  defmodule ErrorBase do
    defmacro __using__(default) do
      quote do
        use Croma.Struct, recursive_new?: true, fields: [
          code:        Croma.String,
          name:        Croma.String,
          description: Croma.String,
          source:      Croma.String,
        ]
        defun new :: t do
          struct(__MODULE__, unquote(default))
            |> Map.put(:source, "gear")
        end
      end
    end
  end

  defmodule BadRequestError do
    use ErrorBase, %{
      code:        "400-06",
      name:        "BadRequest",
      description: "Unable to understand the request.",
    }
  end
  defmodule CredentialError do
    use ErrorBase, %{
      code:        "401-00",
      name:        "InvalidCredential",
      description: "The given credential is invalid.",
    }
  end
  defmodule AuthenticationError do
    use ErrorBase, %{
      code:        "401-01",
      name:        "AuthenticationError",
      description: "The given email, user name and/or password are incorrect.",
    }
  end
  defmodule ResourceNotFoundError do
    use ErrorBase, %{
      code:        "404-04",
      name:        "ResourceNotFound",
      description: "The resource does not exist in the database.",
    }
  end
  defmodule ConflictingUpdateError do
    use ErrorBase, %{
      code:        "409-03",
      name:        "ConflictingUpdate",
      description: "The document version your request is based on is outdated. Check 'currentVersion' for the content of the current document.",
    }
  end
end
