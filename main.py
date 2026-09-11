import os
import sys
from pyrogram import Client, filters
import config

app = Client(
    "KurtUserbot",
    api_id=config.API_ID,
    api_hash=config.API_HASH,
    session_string=config.STRING_SESSION,
    plugins=dict(root="plugins")
)

@app.on_message(filters.me & filters.command("kurt", prefixes="."))
async def kurt_info(client, message):
    info_text = (
        "🐺 **Kurt Userbot Aktif!**\n\n"
        "📢 **Güncelleme:** @KurtUserbot\n"
        "🛠 **Destek:** @KurtSupport\n"
        "🔌 **Plugins:** @KurtPlugins"
    )
    await message.edit_text(info_text)

if __name__ == "__main__":
    print("🐺 Kurt Userbot Başlatılıyor...")
    app.run()
  
