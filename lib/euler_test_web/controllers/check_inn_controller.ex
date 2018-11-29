defmodule EulerTestWeb.CheckInnController do
  @moduledoc false
  use EulerTestWeb, :controller

  def index(conn, _params) do
    alias EulerTest.Repo
    import Ecto.Query
    inn_checks = Repo.all(from EulerTest.InnChecks, order_by: [desc: :checked])
    render(conn, "index.html", history: inn_checks)
  end

end
