using Agents
using CairoMakie
using Agents, Agents.Pathfinding

matrix = [
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 0;
    0 1 0 1 0 0 0 1 1 1 0 1 0 1 0 1 0;
    0 1 1 1 0 1 0 0 0 0 0 1 0 1 1 1 0;
    0 1 0 0 0 1 1 1 1 1 1 1 0 0 0 1 0;
    0 1 0 1 0 1 0 0 0 0 0 1 1 1 0 1 0;
    0 1 1 1 0 1 0 1 1 1 0 1 0 1 0 1 0;
    0 1 0 1 0 1 0 1 1 1 0 1 0 1 0 1 0;
    0 1 0 1 1 1 0 0 1 0 0 1 0 1 1 1 0;
    0 1 0 0 0 1 1 1 1 1 1 1 0 0 0 1 0;
    0 1 1 1 0 1 0 0 0 0 0 1 0 1 1 1 0;
    0 1 0 1 0 1 0 1 1 1 0 0 0 1 0 1 0;
    0 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
]

@agent struct Ghost(GridAgent{2})
    type::String = "Ghost"
end

function initialize_model(matrix)
    maze = BitArray(matrix .== 1)
    space = GridSpace(size(maze); periodic = false)
    pathfinder = AStar(space; walkmap=maze, diagonal_movement=false)
    model = StandardABM(Ghost, space; agent_step!)
    add_agent!((8, 9), model)
    plan_route!(model[1], (2, 2), pathfinder)

    return model, pathfinder
end

agent_step!(agent, model) = move_along_route!(agent, model, pathfinder)
model, pathfinder = initialize_model(matrix)