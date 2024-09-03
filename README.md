# fun7

Fun7 CTS backend service.

## Assignment

1. Write a simple CTS backend application.

    The application is written in Python's FastAPI - primarely for ease of use and simplicty. Should be rewritten in GoLang or C if performance becomes a chronic bottleneck (unlikely).

2. Every git commit should automatically trigger an application build.

    Every commit (or actually push) triggers a docker build of the application, which is then pushed to the ghrc registry. The image is tagged with the commit's short SHA for simplicity.

3. Describe how you would set up infrastructure to be resilient to failures of compute nodes and scale automatically in case of increased CPU. You can also provide configuration files for the infrastructure/tools you would use.

4. Every merge/commit to master should also automatically deploy a new version of CTS.

    Instead of master, the GitHub's default main is used here.
