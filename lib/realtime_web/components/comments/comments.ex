defmodule RealtimeWeb.Components.Comments do
  @moduledoc """
  Functional components related to Comments.
  """

  use Phoenix.Component
  alias Phoenix.LiveView.JS

  attr :comments, :list, required: true
  attr :ready, :boolean, required: true

  def comment_list(assigns) do
    ~H"""
    <div phx-update="stream" id="comments">
      <article
        :for={{id, comment} <- @comments}
        id={id}
        class="p-6 mb-3 text-base bg-white border-t border-gray-200"
        phx-mounted={
          @ready &&
            JS.transition(
              {"ease-in duration-200", "opacity-0 p-0 h-0", "opacity-100"},
              time: 200
            )
        }
      >
        <footer class="flex justify-between items-center mb-2">
          <div class="flex items-center">
            <p class="inline-flex items-center mr-3 text-sm text-gray-900 font-semibold">
              <%= comment.author %>
            </p>
            <p class="text-sm text-gray-600">
              <time>
                <%= comment.inserted_at %>
              </time>
            </p>
          </div>
        </footer>
        <p class="text-gray-500">
          <%= comment.body %>
        </p>
      </article>
    </div>
    """
  end
end
