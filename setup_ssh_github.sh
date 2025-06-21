#!/bin/bash

# ตรวจสอบว่า gh (GitHub CLI) ติดตั้งหรือยัง
if ! command -v gh &> /dev/null
then
    echo "โปรดติดตั้ง GitHub CLI ก่อน: https://cli.github.com/"
    exit 1
fi

read -p "ใส่อีเมลสำหรับ SSH key: " email
key_path="$HOME/.ssh/id_ed25519"

# สร้าง SSH key (ถ้ายังไม่มี)
if [ ! -f "$key_path" ]; then
    ssh-keygen -t ed25519 -C "$email" -f "$key_path" -N ""
else
    echo "พบ SSH key ที่ $key_path แล้ว, ข้ามขั้นตอนสร้าง"
fi

# เริ่ม ssh-agent
eval "$(ssh-agent -s)"

# เพิ่ม key เข้า ssh-agent
ssh-add "$key_path"

# อ่าน public key
pub_key=$(cat "${key_path}.pub")

echo "กำลังเพิ่ม SSH public key เข้า GitHub..."
gh ssh-key add "${key_path}.pub" --title "Key created on $(hostname) at $(date)"

# คลอน repo ผ่าน SSH
echo "กำลังโคลน repo git@github.com:GPKCNR/Thecharmoftwosouls.git"
git clone git@github.com:GPKCNR/Thecharmoftwosouls.git

echo "เรียบร้อย!"
