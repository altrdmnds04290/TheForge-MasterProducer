from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="PhoenixForge-OS-2225 API")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])

@app.get("/")
def root():
    return {"PhoenixForge": "OS-2225", "status": "alive"}

from apps.forge_api.src.routes import feed as feed_route  # type: ignore
app.include_router(feed_route.router, prefix="/feed", tags=["Feed"])  # type: ignore
