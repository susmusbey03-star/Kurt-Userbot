import sys
from pyrogram import Client, filters
from pyrogram.errors import UserNotParticipant, ChatAdminRequired
import config

app = Client(
    "KurtUserbot",
    api_id=config.API_ID,
    api_hash=config.API_HASH,
    session_string=config.STRING_SESSION,
    plugins=dict(root="plugins")
)

async def check_channel_subscriptions(client: Client):
    """Kullanıcının zorunlu kanallara üye olup olmadığını kontrol eder."""
    missing_channels = []
    
    for channel in config.REQUIRED_CHANNELS:
        try:
            await client.get_chat_member(channel, "me")
        except UserNotParticipant:
            missing_channels.append(channel)
        except Exception as e:
            print(f"⚠️ Kanal kontrol edilirken hata oluştu ({channel}): {e}")
            
    return missing_channels

@app.on_message(filters.me & filters.command("kurt", prefixes="."))
async def kurt_info(client, message):
    info_text = (
        "🐺 **Kurt Userbot Aktif!**\n\n"
        "📢 **Güncelleme:** @KurtUserbot\n"
        "🛠 **Destek:** @KurtSupport\n"
        "🔌 **Plugins:** @KurtPlugins"
    )
    await message.edit_text(info_text)

async def main():
    await app.start()
    print("🐺 Kurt Userbot doğrulama kontrolleri yapılıyor...")
    
    missing = await check_channel_subscriptions(app)
    if missing:
        print("\n❌ HATA: Kurt Userbot'u kullanabilmek için zorunlu kanallara katılmalısınız!")
        for ch in missing:
            print(f"   👉 https://t.me/{ch}")
        print("\nKanallara katıldıktan sonra botu tekrar başlatın.\n")
        await app.stop()
        sys.exit(1)
        
    print("✅ Kanal kontrolleri başarılı. Kurt Userbot aktif!")
    await app.idle()

if __name__ == "__main__":
    app.run(main())
    
