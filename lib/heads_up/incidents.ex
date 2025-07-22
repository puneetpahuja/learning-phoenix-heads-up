defmodule HeadsUp.Incidents do
  alias HeadsUp.Incidents.Incident
  alias HeadsUp.Repo
  import Ecto.Query

  def filter_incidents(filter) do
    from(i in Incident,
      where: [status: ^filter["status"]],
      where: ilike(i.name, ^"%#{filter["q"]}%"),
      order_by: [desc: :name]
    )
    |> Repo.all()
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
