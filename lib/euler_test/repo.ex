defmodule EulerTest.Repo do
  use Ecto.Repo,
    otp_app: :euler_test,
    adapter: Ecto.Adapters.Postgres
end
