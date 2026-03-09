from fastapi import APIRouter
router = APIRouter()

posts = [
    {"id": 1, "user": "ALT3R3D-PHO3NIX", "text": "Rising through smoke."},
    {"id": 2, "user": "Altered-Minds", "text": "Wallet empty, lungs full 🌿"}
]

@router.get("/")
def get_feed():
    return posts

@router.post("/")
def add_post(user: str, text: str):
    post = {"id": len(posts)+1, "user": user, "text": text}
    posts.append(post)
    return post
