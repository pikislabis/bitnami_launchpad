# Bitnami Launchpad

This is a project for a Bitnami technical interview.

## Requirements

Create a REST-based API service that given a set of cloud credentials (you can choose AWS or GCP), it will deploy an instance of the Ghost blog engine in a publicly available cloud service and return the URL where to access it.

Since this is API-oriented service, you can create a simple command line to test it. You can choose whatever language you are most comfortable with for both the backend and cli. Something along the lines of

```
$ TOOL_NAME myapiserver --credentials xxxx
```

which will return the URL where to access the deployed application

```
http://10.0.0.1:8080
```

You can go as deeply as you want. It should take you on the order of 2-3 hours to complete. Feel free to dedicate as much time to the project as you would like, but I want to be respectful of your time in the process, so please don't feel compelled to spend more than a few hours.

## Getting Started

To speed up the development process, a [Rails Bitnami Development Containers](https://github.com/bitnami/bitnami-docker-rails) has been used, based on Docker Compose.

To launch the application, execute:

```
$ git clone git@github.com:pikislabis/bitnami_launchpad.git
$ cd bitnami_launchpad
$ docker-compose up
```

Once all the cointainers are up, the API base URL is:

```
http://localhost:3000
```

## Endpoints

There are two endpoints:

### Create Instance

**URL** : `/instances`

**Method** : `POST`

**Body Params**

```json
{
  "access_key_id": "[aws_access_key_id]",
  "secret_access_key": "[aws_secret_access_key]"
}
```

#### Success Response

**Code** : `200 OK`

**Content example**

```json
{
    "id": 1,
    "aws_instance_id": null,
    "instance_status": "pending",
    "public_ip_address": null
}
```

#### Error Response

**Condition** : If `access_key_id` or `secret_access_key` are not present.

**Code** : `422 Unprocessable Entity`

**Content** :

```json
{
    "error": {
        "code": 422,
        "message": {
            "access_key_id": [
                "can't be blank"
            ],
            "secret_access_key": [
                "can't be blank"
            ]
        }
    }
}
```


### Show Instance

**URL** : `/instances/:id`

**Method** : `GET`

#### Success Response

**Code** : `200 OK`

**Content example**

```json
{
    "id": 1,
    "aws_instance_id": "i-04e0206f83dfa83dd",
    "instance_status": "running",
    "public_ip_address": "52.213.31.211"
}
```

#### Error Response

**Condition** : if instance does not exist.

**Code** : `404 Not Found`

**Content** :

```json
{
    "error": {
        "code": 404,
        "message": "The resource is not found"
    }
}
```

## Command Line Testing

The application has a built-in tool for testing purpose:

```
$ ruby create_ghost_instance.rb -u http://localhost:3000 -a <access_key_id> -s <secret_access_key>
```

It will create, using the API Endpoints, a Ghost instance on AWS, showing the status of the instance and its public IP:

```
$ ruby create_ghost_instance.rb -u http://localhost:3000 -a ******* -s ********
Creating Ghost Instance:
Progress: |==================================================================                                                    |
Instance Status: running
Public IP: 34.240.249.116
```

## TODOs

Due to lack of time, there are things that could be done or improved:
* Testing coverage.
* Control duplication of Security Group.
* Code modularization.
* Extend API Endpoints.
