# Xshift

##### Description

```
https://github.com/ginberg/shift_docker_operator.git
```

##### Build & Run

```bash
VERSION=0.0.1
docker build -t ginberg/xshift:$VERSION .
docker push ginberg/xshift:$VERSION
git add -A && git commit -m "$VERSION" && git tag -a $VERSION -m "++" && git push && git push --tags

docker run -it --rm --entrypoint "/bin/bash" ginberg/xshift:$VERSION