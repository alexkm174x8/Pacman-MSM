include("pacman.jl")
using Genie, Genie.Renderer.Json, Genie.Requests, HTTP
using UUIDs

route("/run") do
    run!(model, 1)
    agents = []
    for ghost in allagents(model)
        push!(agents, Dict(
            "id" => string(ghost.id),
            "pos" => ghost.pos,
            "type" => ghost.type
        ))
    end

    json(Dict(:msg => "Actualización de agentes", "agents" => agents))
end

Genie.config.run_as_server = true
Genie.config.cors_headers["Access-Control-Allow-Origin"] = "*"
Genie.config.cors_headers["Access-Control-Allow-Headers"] = "Content-Type"
Genie.config.cors_headers["Access-Control-Allow-Methods"] = "GET,POST,PUT,DELETE,OPTIONS"
Genie.config.cors_allowed_origins = ["*"]

up()
