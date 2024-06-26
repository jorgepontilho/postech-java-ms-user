#Usando a imagem oficial do Maven para compilar o projeto Java
FROM maven:3.8.4-openjdk-17-slim AS build

# Definindo o diretório de trabalho dentro do container
WORKDIR /app

# Copiando o arquivo POM e os arquivos fonte do projeto
COPY pom.xml .
COPY src ./src

# Compilando o projeto com Maven
RUN mvn clean install -DskipTests


#Usando uma imagem base JDK para executar a aplicação Java
FROM openjdk:17-jdk-slim

WORKDIR /app

COPY --from=build /app/target/*.jar /app/msuser.jar

CMD ["java", "-jar", "/app/msuser.jar"]


# Instalando wait-for-it.sh para poder esperar o banco de dados
#RUN apt-get update -y \
#    && apt-get install -y wget netcat \
#    && wget -O /usr/local/bin/wait-for-it.sh https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
#    && chmod +x /usr/local/bin/wait-for-it.sh

# Aguardando até que o banco inicie antes de iniciar a aplicação
#CMD ["/bin/bash", "-c", "wait-for-it.sh -t 0 mysql-user:3306 -- java -jar msuser.jar"]