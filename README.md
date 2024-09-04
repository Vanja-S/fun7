# fun7

Fun7 CTS backend service.

## Assignment

1. Write a simple CTS backend application.

    The application is written in Python's FastAPI - primarely for ease of use and simplicty. Should be rewritten in GoLang or C if performance becomes a chronic bottleneck (unlikely).

2. Every git commit should automatically trigger an application build.

    Every commit (or actually push) triggers a docker build of the application, which is then pushed to the ghrc registry. The image is tagged with the commit's short SHA for simplicity.

3. Describe how you would set up infrastructure to be resilient to failures of compute nodes and scale automatically in case of increased CPU. You can also provide configuration files for the infrastructure/tools you would use.

    For this simple use case the solution uses GCP's Cloud run service. The service is managed by Google Kubernetes Engine (GKE), which orchestrates containers across multiple nodes in a cluster. If one node fails, Kubernetes automatically redistributes the affected containers to other healthy nodes in the cluster, that alongside multi-zone deployments allow for redundancy.

    It also offers autoscalling to accomodate traffic spikes, where CPU is automatically allocated during request processing. Each Cloud run instance can handle multiple requests concurently (up to 80), which is does automatically before spinning up another instance. We can also manually set the minimum number of instances (not implemented here as it runs a passive cost) to help with sudden traffic spikes and decreasing response time due to cold starts.

4. Every merge/commit to master should also automatically deploy a new version of CTS.

    Instead of the master, the GitHub's default main is used here. Whenever a pull request is merged (or a commit is pushed) to the main a commit is created spinning up the _Terraform Provision_ workflow. It will plan and apply any infrastructure change. It will also generate a random UUID which will be used for the Cloud run resource revision number, effectively redeploying them and refreshing their cache always to use the newest tagged `latest` image.

    New versions of the CTS are dockerized and pushed as the tag `latest` when a merge or commit is detected on the main (otherwise tagging is omitted, and the commit's short SHA is used as a tag). The _Docker Image CI_ workflow authenticates to the GCP and pushes the image to the registry provided.

## How to build

This project uses poetry for Python venv and dependency management. To use it, check out their docs [here](https://python-poetry.org/docs/). TL;DR we need to execute the following commands:

1. `poetry init` - which will init the venv and download the Python dependencies needed for development.
2. `fastapi dev main.py` - which will use FastAPI (the underlying Python framework) to spin up a dev server instance.

We can create a new branch from main, develop on it, and when we commit (and push) to it, a new instance of the dockerized application will be created for us with the tag being the commit's short SHA. We can then locally use that image for development and debugging.

When we are ready, we merge the branch into main, which will build the application, tag it as `latest`, and then deploy the infrastructure - if it changed - otherwise it will only deploy a new revision of the Cloud run resources to ensure they are using the latest image (not cached latest) - thus _Terraform Provision_ is triggered by the completion of _Docker Image CI_ to prevent race conditions.

## Architecture

The CTS itself is a basic FastAPI implementation, with the ability to be dockerized. The docker image is created on every commit (any branch) and every merge to main (which are always tagged as latest). The GCP's Cloud run resource is used as a service to host these dockerized applications. They are managed using terraform - which itself uses the GCP's cloud storage to store its state (downloaded and reuploaded in the CI for simplicity, there is a backend option in Terraform but is lacking in security mesuares for handling secrets).

![image](https://github.com/user-attachments/assets/d15e3313-5db3-4916-b777-fafc63f8e7ed)
