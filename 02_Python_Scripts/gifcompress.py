import os
# --- THE FIX STARTS HERE ---
# This forces the newer Pillow library to accept the old command
import PIL.Image
if not hasattr(PIL.Image, 'ANTIALIAS'):
    PIL.Image.ANTIALIAS = PIL.Image.LANCZOS
# --- THE FIX ENDS HERE ---

from moviepy.editor import VideoFileClip

# Paths
input_path = "../05_Exports/PowerBI.gif"
output_path = "../05_Exports/PowerBI_Demo.gif" 

print("Loading GIF... (This might take a minute)")

try:
    clip = VideoFileClip(input_path)

    # 1. Resize: Shrink width to 800px 
    clip_resized = clip.resize(width=800)

    # 2. Write GIF: Reduce FPS to 10
    print("Compressing and saving...")
    clip_resized.write_gif(output_path, fps=12, colors=128)

    print("Done! Check the 05_Exports folder.")

except Exception as e:
    print(f"Error: {e}")