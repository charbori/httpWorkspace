docker build -t test_container .
docker run -d -p 80:80 test_container