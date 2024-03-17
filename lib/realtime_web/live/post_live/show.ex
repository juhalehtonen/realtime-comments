defmodule RealtimeWeb.PostLive.Show do
  use RealtimeWeb, :live_view
  import RealtimeWeb.Components.Comments

  alias Realtime.Content

  @impl true
  def mount(_params, _session, socket) do
    RealtimeWeb.Endpoint.subscribe("post:comments")

    {:ok, assign(socket, :ready, false)}
  end

  @impl true
  def handle_params(_params, _session, socket) do
    post = Content.get_post()
    comments = Content.list_comments(post.id)

    {:noreply,
     socket
     |> assign(:page_title, post.title)
     |> assign(:post, post)
     |> assign(:comment, %Content.Comment{})
     |> stream(:comments, comments)}
  end

  # Handler for posting to the "post:comments" PubSub topic after a comment is saved
  # by the current LiveView. This will broadcast the new comment to all subscribers.
  @impl true
  def handle_info({RealtimeWeb.PostLive.CommentFormComponent, {:saved, comment}}, socket) do
    RealtimeWeb.Endpoint.broadcast_from(self(), "post:comments", "new", comment)

    {:noreply, socket |> stream_insert(:comments, comment) |> assign(:ready, true)}
  end

  # Handler for listening to the "post:comments" PubSub topic for new comments
  # created by other LiveViews.
  @impl true
  def handle_info(%{topic: "post:comments", payload: state}, socket) do
    {:noreply, stream_insert(socket, :comments, state)}
  end
end
