defmodule EulerTestWeb.PageController do
  use EulerTestWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: "/check-inn")
  end
end
