#!/bin/bash
# Instalación de ffmpeg si no está ya instalado
command -v ffmpeg &> /dev/null || {
    echo "Instalando ffmpeg..."
    sudo apt update && sudo apt install -y ffmpeg
}

# Instalación de yt-dlp si no está (versión de GitHub)
command -v yt-dlp &> /dev/null || {
    echo "Instalando yt-dlp desde GitHub..."
    # Lo instalo de GitHub porque desde apt está desactualizado y me ha dado errores con ciertos videos de YouTube
    sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
    sudo chmod a+rx /usr/local/bin/yt-dlp
}

# Pedimos la URL
read -p "Introduce la URL de YouTube: " URL

# Se muestran los formatos disponibles
echo "Obteniendo formatos disponibles..."
yt-dlp -F "$URL"
read -p "Introduce el código del formato que deseas descargar (ej. 18): " FORMATO

# Descarga del vídeo en formato elegido
yt-dlp -f "$FORMATO" -o "video_descargado.%(ext)s" "$URL"
VIDEO=$(ls video_descargado.*)

# Extraer audio en mp3
ffmpeg -i "$VIDEO" -q:a 0 -map a audio_extraido.mp3
# Extraer video sin audio y comprimir (H.264)
ffmpeg -i "$VIDEO" -an -vcodec libx264 -preset slow -crf 28 video_sin_audio.mp4

# Mostrar info de ambos archivos
echo "Información del audio:"
ffmpeg -i audio_extraido.mp3
echo "Información del vídeo:"
ffmpeg -i video_sin_audio.mp4

# Y fin !
echo "Script finalizado :)"
