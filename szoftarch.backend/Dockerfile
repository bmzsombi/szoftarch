FROM eclipse-temurin:21 AS base
WORKDIR /opt/app

EXPOSE 5000

FROM maven:3.9.6-eclipse-temurin-21 AS compile
WORKDIR /opt/src/szoftarch.backend
COPY pom.xml .
RUN mvn compile

FROM compile AS package
COPY ./src ./src
RUN mvn package

FROM base AS final
# Ellenőrizd, hogy a fájl létezik a package fázis után, és a helyes fájlnevet adod meg
COPY --from=package /opt/src/szoftarch.backend/target/szoftarch.backend-1.0-SNAPSHOT.jar .
CMD ["java", "-jar", "/opt/app/szoftarch.backend-1.0-SNAPSHOT.jar"]