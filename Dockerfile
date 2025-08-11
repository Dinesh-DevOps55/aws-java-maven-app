FROM amazoncorretto:8-alpine3.17-jre

EXPOSE 8080

# Copy the jar with a wildcard so it works for any version
COPY ./target/java-maven-app-*.jar /usr/app/app.jar

WORKDIR /usr/app

ENTRYPOINT ["java", "-jar", "app.jar"]
