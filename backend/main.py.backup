import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from backend import core

os.environ['HF_HOME'] = os.path.expanduser("~/lumi_app/ai_models")

app = FastAPI()
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])

class Entry(BaseModel):
    lines: list[str]

@app.post("/predict")
async def predict_color(entry: Entry):
    return core.analyze_lines(entry.lines)

class TextEntry(BaseModel):
    text: str

@app.post("/predict_text")
async def predict_text(entry: TextEntry):
    return core.analyze_text(entry.text)

@app.post("/calibrate")
async def calibrate(entry: dict):
    return {"results": [{"text": t, "prediction": core.analyze_text(t)} for t in entry.get("texts", [])]}

@app.get("/calibrate_sample")
async def calibrate_sample():
    samples = [
        "My dog died",
        "I got a promotion",
        "I'm anxious about exams",
        "This is disgusting",
        "Wow, that's amazing!",
        "I'm looking forward to tomorrow"
    ]
    return {"results": [{"text": t, "prediction": core.analyze_text(t)} for t in samples]}

# app is importable for compatibility
