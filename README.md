# Realtime

You need Elixir installed on your system to run Realtime. If you use `asdf` to manage your Elixir instalation, you can run `asdf install` in the project's root directory to install compatible versions of Elixir and Erlang.

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Realtime uses Credo and Dialyzer for static code analysis. When developing Realtime, utilize these tools to avoid regressions in quality or test coverage.

## Project Overview: Trade-offs, Assumptions, and Decision Log

This section outlines key decisions and trade-offs made in Realtime's development, providing insight into our reasoning to aid future development and informed decision-making.

### Choosing ETS over traditional RDBMS

In many Phoenix-based projects, the default choice of PostgreSQL as the RDBMS offers a straightforward path to achieving 90% functionality with minimal manual coding, thanks to Phoenix's generators and conventions. However, Realtime deliberately deviates from this path, opting for ETS as its storage layer. This choice is driven by the desire to stimulate more engaging discussions around the project's architecture, despite the practical benefits of conventional RDBMS in real-world applications.

#### Limitations of chosen ETS approach

In addition to the general tradeoffs between ETS and PostgreSQL (the default choice with Phoenix projects), there are some notable downsides:

  - **Single-node constraint**: ETS only runs on a single Elixir node, limiting the ability to scale horizontally through clustering without adopting a more distributed storage solution.
  - **Complex Table Management**: My approach for increased robustness introduces unnecessary complexity in table management for Realtime, which could be avoided with simpler solutions. The approach could be valuable in a real world project, but adds complexity to this toy project.

### Constrained feature set

Realtime intentionally limits its features to managing Comments on a single Post, adhering closely to the project's original scope. This design choice excludes the management of Posts, aligning with the task's given objective.

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
