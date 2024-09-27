"use client"
import styles from "./page.module.css";
import React, { useEffect, useState } from 'react';

export default function Home() {
  const [posX, setPosX] = useState(8); // Fila (Y)
  const [posY, setPosY] = useState(8); // Columna (X)

  const matrix = [
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0],
    [0, 1, 0, 1, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0],
    [0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0],
    [0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0],
    [0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0],
    [0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0],
    [0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0],
    [0, 1, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 1, 1, 1, 0],
    [0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0],
    [0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0],
    [0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 1, 0, 1, 0],
    [0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  ];

  useEffect(() => {
    const interval = setInterval(() => {
      fetch("http://localhost:8000/run")
        .then(res => res.json())
        .then(res => {
          if (res.agents.length > 0) {
            console.log("Nueva posición del fantasma:", res.agents[0].pos);
            console.log("Datos recibidos:", res);
            const [y, x] = res.agents[0].pos; 
            setPosY(x - 1);
            setPosX(y - 1);
          }
        })
        .catch(error => console.error("Error al obtener datos:", error));
    }, 1000);

    return () => clearInterval(interval);
  }, []);

  return (
    <div>
      <svg width="800" height="500" xmlns="http://www.w3.org/2000/svg">
        {
          matrix.map((row, rowidx) =>
            row.map((value, colidx) =>
              <rect 
                key={`${rowidx}-${colidx}`}
                x={250 + 24 * colidx} 
                y={5 + 24 * rowidx} 
                width={24} 
                height={24} 
                fill={value === 1 ? "black" : "darkblue"}
              />
          ))
        }
        {}
        <image 
          x={250 + 24 * posY} 
          y={5 + 24 * posX} 
          width="24" 
          height="24" 
          href="ghost.png" 
          alt="Ghost"
        />
        {}
        <image 
          x={250 + 24 * 1} 
          y={5 + 24 * 1} 
          width="24" 
          height="24" 
          href="pacman.png" 
          alt="Pacman"
        />
      </svg>
    </div>
  );
}