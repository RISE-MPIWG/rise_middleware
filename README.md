Rise Platform - Max Planck Institute for the History of Science, Department III

# Dependencies:

Docker

# Deployment:
Install Docker on your machine, clone the repo, and run 

    docker-compose up --build

In the application's folder.

application should be available at http://your docker vm ip/:3000 - if you use the docker app on mac http://localhost:4000 should work.

You will also need to create the database and run the migrations: Once the app is running, get into the running web container by doing (assuming the app folder is called rise):

     docker exec -it rise_web_1 bash

This should get you in the bash of the container; Then just run the following:

     rake db:create && rake db:migrate && rake db:seed

and you should be good to go! Please note that this is still very much a work in progress at the moment and stability is not garanteed.

# Production Deployment:

  export DOCKER_HOST=141.14.214.238:2375
to set the production server as docker host, and then

     docker-compose -f docker-compose.production.yml build
     docker-compose -f docker-compose.production.yml push
     docker stack rm rise
     docker stack deploy -c docker-compose.production.yml rise --with-registry-auth

