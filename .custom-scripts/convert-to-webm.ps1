throw "no tested - and webp is better anyway"
ffmpeg -framerate 30 -i image%03d.png -c:v libvpx-vp9 -pix_fmt yuva420p output.webm