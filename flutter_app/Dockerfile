# Alapértelmezett nginx image használata
FROM nginx:alpine

# Az nginx alapértelmezett portjának a kinyitása
EXPOSE 80

# A Flutter web build fájlokat másoljuk az nginx szerverbe
COPY build/web /usr/share/nginx/html

# Az nginx szerver elindítása
CMD ["nginx", "-g", "daemon off;"]
