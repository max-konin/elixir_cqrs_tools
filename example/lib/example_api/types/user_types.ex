defmodule ExampleApi.Types.UserTypes do
  @moduledoc false
  use Cqrs.Absinthe
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  alias Example.Queries.{ListUsers, GetUser}
  alias Example.Users.Messages.{CreateUser, SuspendUser, ReinstateUser}

  import ExampleApi.Resolvers.UserResolver

  enum :user_status do
    value :active
    value :suspended
  end

  object :user do
    field :id, :id
    field :name, :string
    field :email, :string
    field :status, :user_status
  end

  connection(node_type: :user)

  object :user_queries do
    derive_query GetUser, :user,
      as: :user,
      except: [:name]

    derive_connection ListUsers, :user,
      as: :users,
      repo: Example.Repo,
      status: :user_status
  end

  derive_mutation_input CreateUser

  object :user_mutations do
    derive_mutation CreateUser, :user, then: &fetch_user/1
    derive_mutation SuspendUser, :user, input_object?: false, then: &fetch_user/1
    derive_mutation ReinstateUser, :user, input_object?: false, then: &fetch_user/1
  end
end
