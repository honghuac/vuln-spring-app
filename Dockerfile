FROM maven:3.5-jdk-9 as build
ENV DD_APPSEC_ENABLED=true
WORKDIR /app

COPY ./app/pom.xml .
RUN mkdir /maven && mvn -Dmaven.repo.local=/maven -B dependency:go-offline

COPY ./app/src ./src
RUN mvn -Dmaven.repo.local=/maven package


FROM tomcat:9.0.59-jdk11-openjdk-slim-buster
LABEL org.opencontainers.image.source="https://github.com/DataDog/security-labs-pocs/"
RUN mkdir -p /app
WORKDIR /app

COPY --from=build /app/target/ROOT.war /usr/local/tomcat/webapps/
EXPOSE 8080
CMD ["catalina.sh", "run"]