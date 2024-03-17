defmodule Realtime.ContentTest do
  use ExUnit.Case, async: false
  alias Realtime.Content
  alias Realtime.Content.Comment

  describe "comments" do
    setup do
      on_exit(fn -> Realtime.TestSupport.reset_ets() end)
      :ok
    end

    test "list_comments/1 returns all comments for a given post_id" do
      comments = insert_comments()
      assert Content.list_comments(1) == comments
    end

    test "create_comment/1 with valid data creates a comment" do
      valid_attrs = %{body: "some body", author: "some username", post_id: 1}

      assert {:ok, %Comment{} = comment} = Content.create_comment(valid_attrs)
      assert comment.body == "some body"
      assert comment.author == "some username"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_comment(%{foo: "bar"})
    end

    test "change_comment/1 returns a comment changeset" do
      comment = insert_comments() |> hd()
      assert %Ecto.Changeset{} = Content.change_comment(comment)
    end
  end

  defp insert_comments do
    comment_params = [
      %{post_id: 1, body: "some body", author: "some username"},
      %{post_id: 1, body: "another body", author: "another username"}
    ]

    Enum.map(comment_params, fn params ->
      {:ok, comment} = Content.create_comment(params)
      comment
    end)
  end
end
