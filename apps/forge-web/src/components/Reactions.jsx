import React, { useState } from "react";
export default function Reactions(){
  const [likes, setLikes] = useState(0);
  const [flares, setFlares] = useState(0);
  return (
    <div className="flex gap-3 mt-2">
      <button className="px-2 py-1 bg-amber-600 rounded" onClick={()=>setLikes(likes+1)}>👍 {likes}</button>
      <button className="px-2 py-1 bg-red-600 rounded" onClick={()=>setFlares(flares+1)}>🔥 {flares}</button>
    </div>
  )
}
