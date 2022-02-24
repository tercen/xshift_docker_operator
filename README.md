# Xshift

##### Description

This is a docker wrapper for the xshift operator.

##### Build & Run

```bash
VERSION=0.0.1
docker build -t tercen/xshift:$VERSION .
docker push tercen/xshift:$VERSION
git add -A && git commit -m "$VERSION" && git tag -a $VERSION -m "++" && git push && git push --tags

docker run -it --rm --entrypoint "/bin/bash" tercen/xshift:$VERSION