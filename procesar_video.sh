#!/bin/bash

# Comprobar dependencias
for cmd in yt-dlp ffmpeg; do
    if ! command -v $cmd &> /dev/null; then
        echo "$cmd no está instalado. Instalando..."
        sudo apt update && sudo apt install -y $cmd
    fi
done

# Pedir URL
read -p "Introduce la URL de YouTube: " URL

# Mostrar formatos disponibles
echo "Obteniendo formatos disponibles..."
yt-dlp -F "$URL"
read -p "Introduce el código del formato que deseas descargar (ej. 18): " FORMATO

# Descargar vídeo en formato elegido
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

echo "Script finalizado :)"
