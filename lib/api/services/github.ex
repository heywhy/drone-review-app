defmodule ReviewApp.Services.Github do

  import Ecto.Query

  alias ReviewApp.Models.User
  alias ReviewApp.Clients.Github
  alias ReviewApp.Models.Repository

  def sync_repos(%User{} = user, pid) do
    spawn(fn() ->
      sync_repos(user)
      send(pid, {:sync_repos, :done})
    end)
  end

  def sync_repos(%User{} = user) do
    with {200, repos, _} <- Tentacat.Repositories.list_mine(Github.initiate_client(user)) do
      repos = repos
      |> filter_repos()
      |> Enum.reduce(%{}, &(Map.put &2, &1["node_id"], &1))

      ReviewApp.Repo.transaction(fn ->
        now = DateTime.utc_now() |> DateTime.truncate(:second)
        repos
        |> update_existing(now)
        |> new_repos(now)
      end)
    end
  end

  @spec existing_repos(keyword) :: Paginator.Page.t()
  def existing_repos(opts \\ []) do
    query = from(r in Repository)
    ReviewApp.Repo.paginate(query, [limit: 15, cursor_fields: [:id, :full_name]] ++ opts)
  end

  def new_repos(repos, now) do
    new_repos = repos
    |> Enum.map(fn({_, val}) -> Repository.changeset(%Repository{}, val) end)
    |> Enum.filter(fn (%Ecto.Changeset{} = changeset) -> changeset.valid? end)
    |> Enum.map(fn(%{changes: changes}) ->
      changes
      |> Map.put(:inserted_at, now)
      |> Map.put(:updated_at, now)
    end)

    if !Enum.empty?(new_repos) do
      ReviewApp.Repo.insert_all(Repository, new_repos)
    end
  end

  defp update_existing(repos, now) do
    changes = from(Repository)
    |> ReviewApp.Repo.stream()
    |> Stream.filter(fn (%Repository{} = repo) ->
      if Map.has_key?(repos, repo.node_id) do
        attrs = Map.get(repos, repo.node_id, %{}) |> Map.put(:updated_at, now)
        changeset = Repository.update_changeset(repo, attrs)
        changeset.valid?
      else
        false
      end
    end)
    |> Stream.map(fn repo ->
      Map.from_struct(repo)
      |> Map.drop([:__meta__, :activator])
      |> Map.put(:updated_at, now)
    end)
    |> Enum.to_list()

    if Enum.empty?(changes) do
      repos
    else
      ReviewApp.Repo.insert_all(Repository, changes, on_conflict: :replace_all)
      keys = changes |> Enum.map(&(&1.node_id))
      repos |> Map.drop(keys)
    end
  end

  defp filter_repos(repos) when is_list(repos) do
    filters = get_repo_filters()
    |> String.split(",")
    |> Enum.map(fn filter ->
      filter = cond do
        String.ends_with?(filter, "/*") -> filter <> "*"
        String.ends_with?(filter, "/**") -> filter
        true -> filter <> "/**"
      end

      ExMinimatch.compile("**/" <> filter)
    end)

    Enum.filter(repos, fn repo ->
      Enum.any?(filters, &(ExMinimatch.match(&1, repo["full_name"])))
    end)
  end

  defp get_repo_filters, do: Application.get_env(:review_app, ReviewApp)[:repository_filter]
end
