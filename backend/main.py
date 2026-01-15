import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional
from backend import core
from backend import database

os.environ['HF_HOME'] = os.path.expanduser("~/lumi_app/ai_models")

app = FastAPI()
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])

class Entry(BaseModel):
    lines: list[str]
    user_id: Optional[str] = None

def hue_to_hex(hue):
    """Convert HSL hue (0-360) to RGB hex color with saturation=0.85, lightness=0.65"""
    import colorsys
    if hue is None:
        return "#808080"  # Grey for neutral
    # Convert HSL to RGB (colorsys uses 0-1 range)
    r, g, b = colorsys.hls_to_rgb(hue / 360.0, 0.65, 0.85)
    return f"#{int(r*255):02x}{int(g*255):02x}{int(b*255):02x}"

@app.post("/predict")
async def predict_color(entry: Entry):
    result = core.analyze_lines(entry.lines)

    # Save to database if user_id provided
    if entry.user_id and database.supabase:
        # Extract confidence as integer (e.g., "85.3%" -> 95)
        confidence_str = result.get("confidence", "0%")
        mood_score = int(float(confidence_str.rstrip('%')))

        # Convert hue to hex color
        hue = result.get('hue')
        color_hex = hue_to_hex(hue)

        # Save to database
        save_result = database.save_daily_color(
            user_id=entry.user_id,
            emotion=result.get("emotion", "Neutral"),
            color_hex=color_hex,
            mood_score=mood_score,
            description=result.get("summary", "")
        )

        # Log the save result
        if "error" in save_result:
            print(f"[ERROR] Failed to save to database: {save_result['error']}")
        else:
            print(f"[OK] Saved entry to database for user: {entry.user_id}")

    return result

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

# Database endpoints
@app.get("/colors/{user_id}")
async def get_user_colors(user_id: str, limit: int = 30):
    """Get recent daily colors for a user"""
    colors = database.get_user_colors(user_id, limit)
    return {"colors": colors}

@app.get("/colors/{user_id}/date/{date}")
async def get_color_by_date(user_id: str, date: str):
    """Get daily color for a specific date (format: YYYY-MM-DD)"""
    color = database.get_color_by_date(user_id, date)
    return {"color": color}

@app.get("/colors/{user_id}/range")
async def get_colors_by_range(user_id: str, start_date: str, end_date: str):
    """Get daily colors within a date range"""
    colors = database.get_colors_by_date_range(user_id, start_date, end_date)
    return {"colors": colors}

@app.get("/stats/{user_id}")
async def get_mood_stats(user_id: str, days: int = 30):
    """Get mood statistics for charts"""
    stats = database.get_mood_stats(user_id, days)
    return stats

@app.get("/community/mood-today")
async def get_community_mood_today():
    """Get aggregated mood statistics for all users today (anonymous)"""
    stats = database.get_community_mood_today()
    return stats

class SummarizeRequest(BaseModel):
    reflections: list[str]

@app.post("/summarize")
async def summarize_reflections(request: SummarizeRequest):
    """Summarize multiple journal reflections without offering advice"""
    if not request.reflections:
        return {"summary": "No reflections to summarize."}

    # Simple concatenation with formatting for readability
    # Just present what they wrote without analysis or advice
    summary_parts = []
    for reflection in request.reflections:
        # Clean up the text
        text = reflection.strip()
        if text:
            summary_parts.append(text)

    if not summary_parts:
        return {"summary": "No reflections found in the selected time period."}

    # Join with periods and proper spacing
    summary = ". ".join(summary_parts)
    if not summary.endswith('.'):
        summary += '.'

    return {"summary": summary}

# app is importable for compatibility
