import os
from supabase import create_client, Client
from dotenv import load_dotenv
from datetime import date
from typing import Optional, List

load_dotenv()

# Initialize Supabase client
supabase_url = os.getenv("SUPABASE_URL")
supabase_key = os.getenv("SUPABASE_KEY")

supabase: Optional[Client] = None

if supabase_url and supabase_key:
    try:
        supabase = create_client(supabase_url, supabase_key)
        print("[OK] Supabase connected successfully")
    except Exception as e:
        print(f"[ERROR] Failed to connect to Supabase: {e}")
else:
    print("[WARNING] Supabase credentials not found. Database features disabled.")


def save_daily_color(
    user_id: str,
    emotion: str,
    color_hex: str,
    mood_score: int,
    description: Optional[str] = None
) -> dict:
    """Save a daily color entry to the database"""
    if not supabase:
        return {"error": "Database not configured"}

    try:
        data = {
            "user_id": user_id,
            "date": str(date.today()),
            "color_hex": color_hex,
            "mood": emotion,
            "mood_score": mood_score,
            "description": description,
        }

        result = supabase.table("daily_colors").insert(data).execute()
        return {"success": True, "data": result.data}
    except Exception as e:
        return {"error": str(e)}


def get_user_colors(user_id: str, limit: int = 30) -> List[dict]:
    """Get recent daily colors for a user"""
    if not supabase:
        return []

    try:
        result = supabase.table("daily_colors")\
            .select("*")\
            .eq("user_id", user_id)\
            .order("date", desc=True)\
            .limit(limit)\
            .execute()

        return result.data
    except Exception as e:
        print(f"Error fetching user colors: {e}")
        return []


def get_colors_by_date_range(user_id: str, start_date: str, end_date: str) -> List[dict]:
    """Get daily colors for a user within a date range"""
    if not supabase:
        return []

    try:
        result = supabase.table("daily_colors")\
            .select("*")\
            .eq("user_id", user_id)\
            .gte("date", start_date)\
            .lte("date", end_date)\
            .order("date", desc=False)\
            .execute()

        return result.data
    except Exception as e:
        print(f"Error fetching colors by date range: {e}")
        return []


def get_color_by_date(user_id: str, target_date: str) -> Optional[dict]:
    """Get daily color for a specific date"""
    if not supabase:
        return None

    try:
        result = supabase.table("daily_colors")\
            .select("*")\
            .eq("user_id", user_id)\
            .eq("date", target_date)\
            .limit(1)\
            .execute()

        return result.data[0] if result.data else None
    except Exception as e:
        print(f"Error fetching color by date: {e}")
        return None


def get_mood_stats(user_id: str, days: int = 30) -> dict:
    """Get mood statistics for chart of the day"""
    if not supabase:
        return {}

    try:
        # Get recent entries
        colors = get_user_colors(user_id, limit=days)

        # Count moods
        mood_counts = {}
        for entry in colors:
            mood = entry.get("mood", "Neutral")
            mood_counts[mood] = mood_counts.get(mood, 0) + 1

        total = len(colors)
        mood_percentages = {
            mood: round(count / total * 100, 1) if total > 0 else 0
            for mood, count in mood_counts.items()
        }

        return {
            "total_entries": total,
            "mood_counts": mood_counts,
            "mood_percentages": mood_percentages
        }
    except Exception as e:
        print(f"Error calculating mood stats: {e}")
        return {}


def get_community_mood_today() -> dict:
    """Get aggregated mood statistics for ALL users today (anonymous)"""
    if not supabase:
        return {"error": "Database not configured"}

    try:
        today = str(date.today())

        # Get all entries for today (all users, anonymous)
        result = supabase.table("daily_colors")\
            .select("mood")\
            .eq("date", today)\
            .execute()

        entries = result.data if result.data else []

        # Count moods
        mood_counts = {}
        for entry in entries:
            mood = entry.get("mood", "Neutral")
            mood_counts[mood] = mood_counts.get(mood, 0) + 1

        total = len(entries)
        mood_percentages = {
            mood: round(count / total * 100, 1) if total > 0 else 0
            for mood, count in mood_counts.items()
        }

        return {
            "date": today,
            "total_entries": total,
            "mood_counts": mood_counts,
            "mood_percentages": mood_percentages
        }
    except Exception as e:
        print(f"Error getting community mood: {e}")
        return {"error": str(e)}
