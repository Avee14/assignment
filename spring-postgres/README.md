## Compose sample application
### Java application with Spring framework and a Postgres database

Project structure:
```
.
├── backend
│   ├── Dockerfile
│   └── ...
├── db
│   └── password.txt
├── compose.yaml
└── README.md

```

## Login to ACR

```
$ az acr login --name <acr-name>

```

## Build Image

```
$ docker build -t <acr-name>.azurecr.io/spring-app:v1 .

```

## Push Image

```
docker push <acr-name>.azurecr.io/spring-app:v1

```

## Update Kubernetes Deployment

```
Change image in:
gitops/spring-app/deployment.yaml

image: <acr-name>.azurecr.io/spring-app:v1

```

After the application starts, you can exec into the pod and do:
```
$ curl localhost:8080
<!DOCTYPE HTML>
<html>
<head>
  <title>Getting Started: Serving Web Content</title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>
	<p>Hello from Docker!</p>
</body>
```

Stop and remove the containers
```
$ kubectl scale deploy <deployment-name> -n <namespace> --replicas=0
```
