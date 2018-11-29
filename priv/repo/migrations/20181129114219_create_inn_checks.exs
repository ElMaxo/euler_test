defmodule EulerTest.Repo.Migrations.CreateInnChecks do
  use Ecto.Migration

  def change do
    create table(:inn_checks) do
      add :inn, :string
      add :checked, :naive_datetime
      add :valid, :boolean, default: false, null: false

      timestamps()
    end

  end
end
