using Agents
using CairoMakie
using DataStructures  # la necesito para el PriorityQueue

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

@agent struct Ghost(GridAgent{2})
  type::String = "Ghost"
end

function heurística(pos1, pos2)
  return abs(pos1[1] - pos2[1]) + abs(pos1[2] - pos2[2])
end

function a_star(agent_pos, target_pos)
  open_list = PriorityQueue{Tuple{Int, Int}, Int}()
  came_from = Dict{Tuple{Int, Int}, Tuple{Int, Int}}()
  g_score = Dict{Tuple{Int, Int}, Int}()
  f_score = Dict{Tuple{Int, Int}, Int}()
  closed_set = Set{Tuple{Int, Int}}()

  start = agent_pos
  goal = target_pos
  g_score[start] = 0
  f_score[start] = heurística(start, goal)
  enqueue!(open_list, start, f_score[start])

  while !isempty(open_list)
      current = dequeue!(open_list)

      if current == goal
          path = []
          while haskey(came_from, current)
              push!(path, current)
              current = came_from[current]
          end
          return reverse(path)  
      end

      push!(closed_set, current)

      for move in movimientos
          (dx, dy) = move
          neighbor = (current[1] + dx, current[2] + dy)

          if 1 <= neighbor[1] <= size(matrix, 1) && 
             1 <= neighbor[2] <= size(matrix, 2) && 
             matrix[neighbor[1], neighbor[2]] == 1 && 
             !(neighbor in closed_set)

              tentative_g_score = g_score[current] + 1

              if !haskey(g_score, neighbor) || tentative_g_score < g_score[neighbor]
                  came_from[neighbor] = current
                  g_score[neighbor] = tentative_g_score
                  f_score[neighbor] = g_score[neighbor] + heurística(neighbor, goal)

                  if !(neighbor in keys(open_list))
                      enqueue!(open_list, neighbor, f_score[neighbor])
                  end
              end
          end
      end
  end
  return []
end

function agent_step!(agent, model)
  target = (2, 2)

  if matrix[target[1], target[2]] == 0
      println("Error: La posición de Pacman está en un muro.")
      return
  end

  # busca el camino con A*
  path = a_star(agent.pos, target)

  if !isempty(path)
      move_agent!(agent, path[1], model) # mueve al fantasma
  end
end

function initialize_model()
  space = GridSpace((14, 17); periodic = false, metric = :manhattan)
  model = StandardABM(Ghost, space; agent_step!)
  return model
end

model = initialize_model()
add_agent!(Ghost, pos=(9, 9), model)