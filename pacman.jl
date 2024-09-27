using Agents
using CairoMakie

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

movimientos = [
    (0, 1),  
    (1, 0),  
    (0, -1), 
    (-1, 0)  
]
movimientos_v = []

@agent struct Ghost(GridAgent{2})
    type::String = "Ghost"
end

function agent_step!(agent, model)
    movimientos_v = []

    for move in movimientos
        (dx, dy) = move
        (x, y) = agent.pos .+ (dx, dy)

        if 1 <= x <= size(matrix, 1) && 1 <= y <= size(matrix, 2) && matrix[x, y] == 1
            push!(movimientos_v, (dx, dy)) 
        end
    end

    if !isempty(movimientos_v)
        move = rand(movimientos_v)
        (dx, dy) = move
        new_pos = (agent.pos[1] + dx, agent.pos[2] + dy) 
        move_agent!(agent, new_pos, model)
    end
end

function initialize_model()
    space = GridSpace((13, 17); periodic = false, metric = :manhattan)
    model = StandardABM(Ghost, space; agent_step!)
    return model
end

model = initialize_model()
a = add_agent!(Ghost, pos=(9, 9), model)