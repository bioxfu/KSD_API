docker kill ksd_api
docker rm ksd_api
docker run --name ksd_api -d -p 8282:8080 bioxfu/ksd_api
