
# Klasörde olduğundan emin ol
cd ~/Kurt-Userbot 2>/dev/null || true

cat <<'EOF' > setup.sh
#!/usr/bin/bash

# Renkler
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m'

clear
echo -e "${CYAN}"
echo "  ___ _   _ ___ _  11111_ ___ ______  ______ __   __"
echo " / __| | | / __| |/ / __| __/ __ ) \/ /  _ \\ \ / /"
echo " \__ \ |_| \__ \ ' <\__ \ _||  _ \  /\  __/ \ V / "
echo " |___/\___/|___/_|\_\___/___|____/_/  |_|    |_|  "
echo -e "${YELLOW}           🐺 KURT USERBOT AUTO SETUP 🐺${NC}"
echo -e "${CYAN}--------------------------------------------------${NC}"
sleep 1

# 1. Termux Paket Güncellemesi
echo -e "${GREEN}📦 [1/6] Termux paketleri güncelleniyor...${NC}"
pkg update -y && pkg upgrade -y
pkg install git python nodejs curl -y

# 2. Repo Kontrolü ve Klonlama
if [ ! -f "main.py" ]; then
    if [ ! -d "Kurt-Userbot" ]; then
        echo -e "${GREEN}📥 [2/6] Kurt-Userbot reposu indiriliyor...${NC}"
        git clone https://github.com/Susmusbey/Kurt-Userbot
    fi
    cd Kurt-Userbot || exit 1
fi

# 3. Sanal Ortam (venv)
echo -e "${GREEN}🐍 [3/6] Python venv ortamı oluşturuluyor...${NC}"
python3 -m venv venv
source venv/bin/activate

# 4. Kütüphaneler ve PM2
echo -e "${GREEN}📥 [4/6] Bağımlılıklar ve PM2 kuruluyor...${NC}"
pip install --upgrade pip
pip install pyrogram tgcrypto
npm install -g pm2

# 5. Dizinler ve Config Yapılandırması
mkdir -p plugins

echo ""
echo -e "${YELLOW}⚙️  Kurt Userbot Konfigürasyon Girişi${NC}"
echo -e "${CYAN}--------------------------------------------------${NC}"
read -p "API ID giriniz       : " api_id
read -p "API HASH giriniz     : " api_hash
read -p "STRING SESSION girin : " string_session

cat <<EOC > config.py
API_ID = $api_id
API_HASH = "$api_hash"
STRING_SESSION = "$string_session"
REQUIRED_CHANNELS = ["KurtUserbot", "KurtSupport", "KurtPlugins"]
EOC

echo -e "${GREEN}✅ config.py oluşturuldu!${NC}"

# 6. PM2 İle Başlatma
echo -e "${GREEN}🚀 [6/6] Kurt Userbot PM2 ile çalıştırılıyor...${NC}"
pm2 start venv/bin/python3 --name kurt-userbot -- main.py
pm2 save

echo ""
echo -e "${PURPLE}==================================================${NC}"
echo -e "${GREEN}🎉 KURULUM TAMAMLANDI! KURT USERBOT AKTİF!${NC}"
echo -e "${PURPLE}==================================================${NC}"
echo -e "${CYAN}• Canlı Loglar  :${NC} pm2 logs kurt-userbot"
echo -e "${CYAN}• Bot Durumu   :${NC} pm2 status"
echo -e "${CYAN}• Yeniden Başlat:${NC} pm2 restart kurt-userbot"
EOF

chmod +x setup.sh
git add setup.sh
git commit -m "feat: add automated setup script"
git push
