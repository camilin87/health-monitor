defmodule HMServerWeb.ApiBeatView do
  use HMServerWeb, :view

  def render("success.json", _params) do
    %{success: true}
  end
end