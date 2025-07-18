defmodule HeadsUpWeb.IncidentLive.Show do
  alias HeadsUp.Incidents
  use HeadsUpWeb, :live_view

  def mount(%{"id" => id}, _session, socket) do
    incident = Incidents.get_incident(id)
    urgent_incidents = Incidents.urgent_incidents(incident)

    {:ok,
     assign(socket,
       page_title: incident.name,
       incident: incident,
       urgent_incidents: urgent_incidents
     )}
  end

  def render(assigns) do
    ~H"""
    <div class="incident-show">
      <div class="incident">
        <img src={@incident.image_path} />
        <section>
          <.badge status={@incident.status} />
          <header>
            <h2>{@incident.name}</h2>
            <div class="priority">
              {@incident.priority}
            </div>
          </header>
          <div class="description">
            {@incident.description}
          </div>
        </section>
      </div>
      <div class="activity">
        <div class="left"></div>
        <div class="right">
          <.urgent_incidents incidents={@urgent_incidents} />
        </div>
      </div>
      <.back navigate={~p"/incidents"}>All Incidents</.back>
    </div>
    """
  end

  attr :incidents, :list, required: true

  def urgent_incidents(assigns) do
    ~H"""
    <section>
      <h4>Urgent Incidents</h4>
      <ul class="incidents">
        <li :for={incident <- @incidents}>
          <.link navigate={~p"/incidents/#{incident.id}"}>
            <img src={incident.image_path} />
            {incident.name}
          </.link>
        </li>
      </ul>
    </section>
    """
  end
end
