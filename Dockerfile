FROM amazoncorretto:8-alpine3.17-jre

# Expose application port
EXPOSE 8080

# Copy the generated JAR (any version) into the image as app.jar
COPY ./target/aws-java-maven-app-*.jar /usr/app/app.jar

WORKDIR /usr/app

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
