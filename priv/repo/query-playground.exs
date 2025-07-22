import Ecto.Query
alias HeadsUp.Incidents.Incident
alias HeadsUp.Repo

msg = "all the pending incidents, ordered by descending priority"
(from Incident,
where: [status: :pending],
order_by: [desc: :priority]) 
|> Repo.all() |> IO.inspect(label: msg)

msg = "incidents with a priority greater than or equal to 2, ordered by ascending name"
(from i in Incident,
where: i.priority >= 2,
order_by: :name) 
|> Repo.all() |> IO.inspect(label: msg)

msg = "incidents that have \"meow\" anywhere in the description"
(from i in Incident,
where: ilike(i.description, "%meow%")) 
|> Repo.all() |> IO.inspect(label: msg)

msg = "the first incident"
Incident |> first(:id) |> Repo.one() |> IO.inspect(label: msg)

msg = "the last incident"
Incident |> last(:id) |> Repo.one() |> IO.inspect(label: msg)
