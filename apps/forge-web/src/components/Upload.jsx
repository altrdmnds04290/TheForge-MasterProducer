import React, { useState } from "react";
export default function Upload(){
  const [file, setFile] = useState(null);
  return (
    <div className="mt-4">
      <h3 className="font-semibold mb-2">Upload Media</h3>
      <input type="file" onChange={(e)=>setFile(e.target.files[0])} className="mb-2" />
      {file && <p className="text-sm text-zinc-400">Selected: {file.name}</p>}
      <button className="bg-amber-600 px-3 py-1 rounded text-white">Upload</button>
    </div>
  )
}
