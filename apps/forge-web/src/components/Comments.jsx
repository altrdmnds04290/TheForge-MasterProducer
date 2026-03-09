import React, { useState } from "react";
export default function Comments({postId}){
  const [comments, setComments] = useState([ {id:1,user:"ALT3R3D-PHO3NIX",text:"🔥 Eternal rise"} ]);
  const [input, setInput] = useState("");
  return (
    <div className="mt-4">
      <h3 className="font-semibold mb-2">Comments</h3>
      <form onSubmit={(e)=>{e.preventDefault(); setComments([...comments,{id:Date.now(),user:"You",text:input}]); setInput("")}}>
        <input value={input} onChange={(e)=>setInput(e.target.value)} placeholder="Leave a comment..." className="w-full bg-zinc-700 text-white p-2 rounded" />
      </form>
      <div className="mt-3 space-y-2">
        {comments.map(c=> (
          <div key={c.id} className="p-2 bg-zinc-800 rounded"><p className="font-bold">{c.user}</p><p>{c.text}</p></div>
        ))}
      </div>
    </div>
  )
}
