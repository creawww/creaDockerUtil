# PROGRAMAS UTILES DE TERMINA (youtube-dl, pdftk, ffmpeg, convert)

Con el tiempo de uso de linux, se va cogiendo cariño al termina, y he ido recopilando algunos programas que resulta muy utile en determinadas ocasiones.

Al cambiar de ordenardor me he dado cuenta que hay que volver a instalar todo, y sobre todo programas que no se usan mucho, pero que son necesarios en determinadas ocasiones.

por ello una solución ideal es docker tener un contenedor con todos esto programas, con la ventaja de tenemos disponibles en cualquier momento para suarlos en cualquier equipo, no ocupan espacio..

INSTRUCCIONES

creacion del contenedor

    docker build -t crea/util .

ya podemos usarpdftk

    docker run --rm --user -v $PWD:/downloads crea/util [pdftk] [youtube-dl] [ffmpeg] [convert]

ejemplo

    docker run --rm -v $PWD:/downloads crea/util convert -layers OptimizePlus -delay 200 -size 260x360 -quality 99 *.png -loop 0 ps1.gif


Para su uso mas comodo podemos cargar los comandos en el la sesion actual de shell con el comando

    source .dockerutil

Algunas combinaciones mas habituales de uso de estos programas

#UTILIDADES

#youtube'dl

es una aplicación que nos permite descargar video de youtube

    youtube-dl http://youtube.com/el-video-que-sea

Leer de Archivo -t para añadir el titulo y -f18 en alta calida,mp4

    youtube-dl -t -f18 -a video.txt

Lista de distrubucion

    youtube-dl -t -f18 https://www.youtube.com/playlist?list=PL53398BADD9369A3F

Convertir a MP3

    youtube-dl -x --audio-format mp3 http://youtube.com/el-video-que-sea

#IMAGENES

## Crear una git animada a partir de varias imagenes

    convert -layers OptimizePlus -delay 200 -size 260x360 -quality 99 *.png -loop 0 ps1.gif

## Convertir imagenes a blanco y negro

    convert -colorspace gray origen.jpg destino.jpg;

Conversión masiva

    for i in *.jpg;do convert -colorspace gray "$i" ${i%.jpg}bn.jpg; done

## Unir varias imagenes en un pdf tamaño A4

    convert -page A4 -compress jpeg *.jpg libro.pdf    


# PDFs

## Desproteger documento PDF

    qpdf --decrypt nombre_pdf_protegido.pdf nombre_pdf_desprotegido.pdf

## Combinar todos los documentos pdf en uno

    pdftk *.pdf output libro.pdf

## Rotar todas la paginas del documento

    pdftk libro.pdf cat 1-endE output rotado.pdf

## Convertir un pdf a imagenes

    convert foo.pdf foo.png    

## Reducir tamaño de documentos PDF

Para realizar la conversión-optimización

    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dQUIET -dBATCH -sOutputFile=optimizado.pdf original.pdf

    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dQUIET -dBATCH -sOutputFile=memoria2014.pdf rotado.pdf

Pero y si ¿aún sigue siendo muy grande? tenemos otro comando que aún lo reduce más:

    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile=optimizado.pdf original.pdf

Otro metodo

    gs -dSAFER -dBATCH -dNOPAUSE -q -dTextAlphaBits=4 -dGraphicsAlphaBits=4 -sDEVICE=pdfwrite -dPDFSETTINGS=/ebook -sOutputFile="memoria2014a.pdf" "memoria2014.pdf"    

## CONVERTIR PDF DE RGB A CMYK

    gs -dSAFER -dBATCH -dNOPAUSE -dNOCACHE -sDEVICE=pdfwrite -sColorConversionStrategy=CMYK -dProcessColorModel=/DeviceCMYK -sOutputFile=document_cmyk.pdf documentoRGB.pdf

# VIDEO

## From DV To AVI  sin comprimir

    ffmpeg -i input.dv -vcodec copy -vtag dvsd -acodec pcm_s16le -f avi -aspect 4:3 -y output.avi

## From DV To MKV comprimido

    ffmpeg -i archivo.dv -c:v libx264 -preset slow -crf 22 -c:a copy archivo.mkv 
    
    Converion masiva
    
    for i in *.dv; do ffmpeg -i "$i"  -c:v libx264 -preset slow -crf 22 -c:a copy "$i".mkv; done
## From FLV to mp4

    ffmpeg -i input.flv -c:v libx264 -crf 19 -strict experimental filename.mp4
    Converion masiva
    for i in *.flv; do ffmpeg -i "$i"  -c:v libx264 -crf 19 -strict experimental "$i".mp4; done

## Convertir de mp4 a mp3

    ffmpeg -i filename.mp4 filename.mp3
    con opciones
    ffmpeg -i filename.mp4 -b: un filename.mp3 -vn 192K
Masiva
for i in *.mp4;do ffmpeg -i $i -q:a 1 -vn ${i%.mp4}.mp3; done

## Convertir de Mp4 a webm
    ffmpeg -i sourcevideo.mp4 -vcodec libvpx -acodec libvorbis -aq 5 -ac 2 -qmax 25 -b 614400 -s 1280×720 Outputvideo.webm 

## Reducir Videos para usarlos de background
 
WebM:

    ffmpeg -i original.mp4 -c:v libvpx -preset slow -s 1024x576 -qmin 0 -qmax 50 -an -b:v 400K -pass 1 homepage.webm

MP4

    ffmpeg -i original.mp4 -c:v libx264 -preset slow -s 1024x576 -an -b:v 370K homepage.mp4
