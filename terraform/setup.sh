#!/bin/bash
sudo apt-get update
sudo apt-get install -y docker.io docker-compose
git clone https://github.com/tatarpower69/Microservices-System.git
cd Microservices-System
sudo docker-compose up -d
