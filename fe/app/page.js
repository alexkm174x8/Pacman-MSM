"use client"
import styles from "./page.module.css";
//import { useState } from "react";
import React, { useEffect, useState } from 'react';


export default function Home() {
  const [posX, setPosX] = useState(7);
  const [posY, setPosY] = useState(8);

  let matrix = [
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
        console.log("Nueva posición del fantasma:", res.agents[0].pos);
        console.log("Datos recibidos:", res);
        setPosX(res.agents[0].pos[0]-1);
        setPosY(res.agents[0].pos[1]-1);
      });
    }, 1000);

      return () => clearInterval(interval);
  }, [posX, posY]);

  return (
    <div>
      <svg width="800" height="500" xmlns="http://www.w3.org/2000/svg">
      {
        matrix.map((row, rowidx) =>
          row.map((value, colidx) =>
            <rect x={250 + 24 * rowidx} y={5 + 24 * colidx} width={24} height={24} fill={value == 1 ? "lightgray" : "gray"}/>
      ))
      }
      <image x={250 + 24 * posX} y={5 + 24 * posY} href="ghost.png"/>
      </svg>
    </div>
  );
}
