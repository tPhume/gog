Logging to elastic search with elastic filebeat demonstration.
Applications are written with Go and the program are run within docker.
### `/app`
Contains the application written with go to demonstrate logging to a file
and using filebeat to send to elastic search.`prod.Dockerfile` contains small standalone alpine multi-stage dockerbuild
for the logging application without filebeat attached. 
### `/elastic`
Contains docker volume mount for the elastic stack (includes configurations files).
