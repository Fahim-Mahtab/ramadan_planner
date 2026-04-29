#!/bin/bash
# Netlify build script: injects environment variables into index.html
sed -i "s|__SUPABASE_URL__|$SUPABASE_URL|g" index.html
sed -i "s|__SUPABASE_ANON_KEY__|$SUPABASE_ANON_KEY|g" index.html
sed -i "s|__BOT_WEBHOOK_URL__|$BOT_WEBHOOK_URL|g" index.html
