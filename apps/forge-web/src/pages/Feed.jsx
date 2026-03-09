import React, { useState } from "react";
import Comments from "../components/Comments";
import Reactions from "../components/Reactions";
import Upload from "../components/Upload";
export default function Feed(){
  const [posts, setPosts] = useState([
    { id: 1, user: "ALT3R3D-PHO3NIX", text: "Rising through smoke." },
    { id: 2, user: "Altered-Minds", text: "Wallet empty, lungs full 🌿" }
  ]);
  const [input, setInput] = useState("");
  return (
    <div className="p-8">
      <h2 className="text-2xl mb-4">Community Feed</h2>
      <form onSubmit={(e)=>{e.preventDefault(); setPosts([...posts,{id:Date.now(),user:"You",text:input}]); setInput("")}}>
        <input value={input} onChange={(e)=>setInput(e.target.value)} placeholder="Post something..." className="w-full p-2 bg-zinc-800 border border-zinc-700 rounded" />
      </form>
      <div className="mt-6 space-y-6">
        {posts.map(p=> (
          <div key={p.id} className="border p-3 bg-zinc-900 rounded">
            <p className="font-semibold">{p.user}</p>
            <p>{p.text}</p>
            <Reactions />
            <Comments postId={p.id} />
            <Upload />
          </div>
        ))}
      </div>
    </div>
  )
}
