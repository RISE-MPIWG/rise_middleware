FROM gitlab/gitlab-runner:ubuntu

MAINTAINER Pascal Belouin <pbelouin@mpiwg-berlin.mpg.de>
ARG DEBIAN_FRONTEND=noninteractive

ARG registration_token
ENV REGISTRATION_TOKEN=$registration_token

ARG url
ENV URL=$url

RUN apt-get update
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN apt-get install -y software-properties-common python-software-properties
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update
RUN apt-cache policy docker-ce
RUN apt-get install -y docker-ce
VOLUME ["/etc/gitlab-runner/config:/etc/gitlab-runner"]
RUN gitlab-runner register -n \
  --url $url \
  --registration-token $registration_token \
  --executor docker \
  --description "RISE docker runner" \
  --docker-image "docker:stable" \
  --docker-volumes /var/run/docker.sock:/var/run/docker.sock
CMD gitlab-runner start
