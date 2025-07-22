defmodule HeadsUpWeb.IncidentLive.Index do
  use HeadsUpWeb, :live_view
  alias HeadsUp.Incidents

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream(:incidents, Incidents.list_incidents())
     |> assign(page_title: "Incidents", form: to_form(%{}))}
  end

  def render(assigns) do
    ~H"""
    <.headline :if={false}>
      <.icon name="hero-trophy-mini" /> 25 Incidents Resolved This Month!
      <:tagline :let={vibe}>
        Thanks for pitching in. {vibe}
      </:tagline>
    </.headline>

    <.filter_form form={@form} />

    <div class="incident-index">
      <div class="incidents" id="incidents" phx-update="stream">
        <.incident_card
          :for={{dom_id, incident} <- @streams.incidents}
          incident={incident}
          id={dom_id}
        />
      </div>
    </div>
    """
  end

  attr :form, :map, required: true

  def filter_form(assigns) do
    ~H"""
    <.form for={@form} id="filter-form" phx-change="filter" phx-submit="filter">
      <.input field={@form[:q]} placeholder="Search..." autocomplete="off" />
      <.input
        type="select"
        field={@form[:status]}
        prompt="Status"
        options={Incidents.status_values()}
      />
      <.input type="select" field={@form[:sort_by]} prompt="Sort By" options={[:name, :priority]} />
    </.form>
    """
  end

  attr :incident, HeadsUp.Incidents.Incident, required: true
  attr :id, :string, required: true

  def incident_card(assigns) do
    ~H"""
    <.link navigate={~p"/incidents/#{@incident.id}"} id={@id}>
      <div class="card">
        <img src={@incident.image_path} />
        <h2>{@incident.name}</h2>
        <div class="details">
          <.badge status={@incident.status} />
          <div class="priority">
            {@incident.priority}
          </div>
        </div>
      </div>
    </.link>
    """
  end

  def handle_event("filter", params, socket) do
    socket =
      socket
      |> assign(form: to_form(params))
      |> stream(:incidents, Incidents.filter_incidents(params), reset: true)

    {:noreply, socket}
  end
end
