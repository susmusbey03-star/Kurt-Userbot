#!/usr/bin/env bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${CYAN}=================================================="
echo "         🐺 KURT USERBOT KURULUMU 🐺             "
echo -e "==================================================${NC}"

echo -e "${YELLOW}[1/4] Paketler güncelleniyor...${NC}"
pkg update -y && pkg upgrade -y

echo -e "${YELLOW}[2/4] Python ve Git kuruluyor...${NC}"
pkg install python git ffmpeg clang make -y

INSTALL_DIR="$HOME/Kurt-Userbot"

if [ -d "$INSTALL_DIR" ]; then
    echo -e "${CYAN}[3/4] Güncellemeler çekiliyor...${NC}"
    cd "$INSTALL_DIR" && git pull
else
    echo -e "${CYAN}[3/4] Kurt Userbot klonlanıyor...${NC}"
    git clone https://github.com/susmusbey03-star/Kurt-Userbot.git "$INSTALL_DIR"
    cd "$INSTALL_DIR"
fi

echo -e "${YELLOW}[4/4] Python ortamı hazırlanıyor...${NC}"
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip setuptools wheel
pip install -r requirements.txt

if [ ! -f "config.py" ]; then
    cp config.py.example config.py
fi

echo -e "\n${GREEN}✅ Kurulum başarıyla tamamlandı!${NC}"
echo -e "Botu başlatmak için: ${CYAN}cd ~/Kurt-Userbot && source venv/bin/activate && python3 main.py${NC}\n"
