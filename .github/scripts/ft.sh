#!/bin/bash

BOT_TOKEN="${TELEGRAM_BOT_TOKEN}"
CHAT_ID="${TELEGRAM_CHAT_ID}"
DEBUG_APK="${DEBUG_APK}"
RUN_ID="${RUN_ID}"
SHORT_SHA="${SHORT_SHA}"
DATE="${DATE}"
REPO="${GITHUB_REPOSITORY}"
BRANCH="${GITHUB_REF_NAME}"
COMMIT="${GITHUB_SHA}"

send_to_telegram() {
    local file=$1
    local caption=$2
    
    if [ ! -f "$file" ]; then
        echo "Error: File not found - $file"
        return 1
    fi
    
    echo "Sending: $(basename "$file")"
    curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendDocument" \
        -F chat_id="${CHAT_ID}" \
        -F document="@${file}" \
        -F caption="${caption}"
}

send_message() {
    local text=$1
    curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
        -d chat_id="${CHAT_ID}" \
        -d text="${text}" \
        -d parse_mode="HTML"
}

if [ -f "$DEBUG_APK" ]; then
    DEBUG_SIZE=$(du -h "$DEBUG_APK" | cut -f1)
    send_to_telegram "${DEBUG_APK}" "Debug APK
Build: #${RUN_ID}
Repository: ${REPO}
Branch: ${BRANCH}
Commit: ${COMMIT}
Date: ${DATE}
Size: ${DEBUG_SIZE}"
else
    echo "Debug APK not found: ${DEBUG_APK}"
fi

send_message "Build Complete!
Status: Success
Repository: ${REPO}
Branch: ${BRANCH}
Commit: ${COMMIT}
Run ID: #${RUN_ID}
Date: ${DATE}

APK sent to Telegram!"

echo "Done!"
