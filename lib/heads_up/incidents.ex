defmodule HeadsUp.Incidents do
  alias HeadsUp.Incidents.Incident
  alias HeadsUp.Repo
  import Ecto.Query

  def filter_incidents(filter) do
    Incident
    |> with_status(filter["status"])
    |> search_by(filter["q"])
    |> sort(filter["sort_by"])
    |> Repo.all()
  end

  defp with_status(query, status) do
    if String.to_atom(status) in status_values() do
      where(query, status: ^status)
    else
      query
    end
  end

  defp search_by(query, q) do
    if q in ["", nil] do
      query
    else
      where(query, [i], ilike(i.name, ^"%#{q}%"))
    end
  end

  defp sort(query, sort_type) do
    sort_param =
      case sort_type do
        "name" -> :name
        "priority_asc" -> :priority
        "priority_desc" -> [desc: :priority]
        _ -> :id
      end

    order_by(query, ^sort_param)
  end

  def list_incidents() do
    Repo.all(Incident)
  end

  def get_incident!(id) do
    Repo.get!(Incident, id)
  end

  def urgent_incidents(incident) do
    from(i in Incident,
      where: i.id != ^incident.id,
      order_by: :priority,
      limit: 3
    )
    |> Repo.all()
  end

  def status_values() do
    Ecto.Enum.values(Incident, :status)
  end
end
