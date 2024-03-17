defmodule RealtimeWeb.PostLiveTest do
  use RealtimeWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "Show" do
    test "displays post", %{conn: conn} do
      {:ok, _show_live, html} = live(conn, ~p"/")

      assert html =~ "My first post"
    end

    test "saves new comment with valid params", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/")

      assert index_live
             |> form("#comment-form",
               comment: %{author: "John", body: "Great post!"}
             )
             |> render_submit()

      html = render(index_live)
      assert html =~ "Great post!"
    end

    test "does not save comment with invalid params", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/")

      assert index_live
             |> form("#comment-form", comment: %{author: "", body: ""})
             |> render_change() =~ "can&#39;t be blank"
    end
  end
end
