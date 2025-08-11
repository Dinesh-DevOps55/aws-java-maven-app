FROM amazoncorretto:8-alpine3.17-jre

EXPOSE 8080

COPY ./target/aws-java-maven-app-1.1.0-SNAPSHOT.jar /usr/app/
WORKDIR /usr/app

ENTRYPOINT ["java", "-jar", "aws-java-maven-app-1.1.0-SNAPSHOT.jar"]
