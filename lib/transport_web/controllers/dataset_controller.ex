defmodule TransportWeb.DatasetController do
  use TransportWeb, :controller
  alias Transport.Datagouvfr.Authentication
  alias Transport.Datagouvfr.Client.Datasets
  alias Transport.Datagouvfr.{Authentication, Client}
  alias Transport.Dataset
  alias Transport.Repo
  require Logger

  def index(%Plug.Conn{} = conn, params), do: list_datasets(conn, params)

  def list_datasets(%Plug.Conn{} = conn, %{} = params) do
    conn
    |> assign(:datasets, get_datasets(params))
    |> render_or_redirect(params)
  end

  defp render_or_redirect(%Plug.Conn{assigns: %{datasets: %{total_entries: 1}}} = conn, _params) do
    entries = conn.assigns[:datasets].entries

    conn
    |> redirect(to: dataset_path(conn, :details, List.first(entries).slug))
  end
  defp render_or_redirect(conn, params) do
    conn
    |> assign(:q, Map.get(params, "q"))
    |> render("index.html")
  end

  def details(%Plug.Conn{} = conn, %{"slug" => slug_or_id}) do
    case Repo.get_by(Dataset, [slug: slug_or_id]) do
      nil -> redirect_to_slug_or_404(conn, slug_or_id)
      dataset ->
        conn
        |> assign(:dataset, dataset)
        |> assign(:discussions, Client.get_discussions(conn, dataset.datagouv_id))
        |> assign(:community_ressources, Client.get_community_ressources(conn, dataset.datagouv_id))
        |> assign(:site, Application.get_env(:oauth2, Authentication)[:site])
        |> assign(:is_subscribed, Datasets.current_user_subscribed?(conn, dataset.datagouv_id))
        |> render("details.html")
    end
  end

  def by_aom(%Plug.Conn{} = conn, %{"commune" => commune}), do: list_datasets(conn, %{"commune" => commune})
  def by_region(%Plug.Conn{} = conn, %{"region" => region}), do: list_datasets(conn, %{"region" => region})
  def by_type(%Plug.Conn{} = conn, %{"type" => type}), do: list_datasets(conn, %{"type" => type})

  defp get_datasets(params) do
    config = make_pagination_config(params)
    select = [:id, :description, :download_url, :format,
     :licence, :logo, :spatial, :title, :slug]

    datasets =
       params
    |> Dataset.list_datasets(select)
    |> Repo.paginate(page: config.page_number)
  end

  defp redirect_to_slug_or_404(conn, slug_or_id) do
    case Repo.get_by(Dataset, [datagouv_id: slug_or_id]) do
      nil ->
        conn
        |> put_status(:internal_server_error)
        |> render(ErrorView, "404.html")
      slug -> redirect(conn, to: dataset_path(conn, :details, slug))
    end
  end
end
