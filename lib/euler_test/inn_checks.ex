defmodule EulerTest.InnChecks do
  use Ecto.Schema
  import Ecto.Changeset


  schema "inn_checks" do
    field :checked, :naive_datetime
    field :inn, :string
    field :valid, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(inn_checks, attrs) do
    inn_checks
    |> cast(attrs, [:inn, :checked, :valid])
    |> validate_required([:inn, :checked, :valid])
  end
end
