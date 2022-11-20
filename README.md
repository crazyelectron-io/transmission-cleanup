# transmission-cleanup

Clean-up files and torrents that have finished seeding.

Create DOCKER_HUB secrets in repository Secrets section (DOCKER_HUB_USERNAME and DOCKER_HUB_TOKEN).

The script will run every X days (in Kubernetes using a CronJob) and cleans any torrent that is finished (as well as the files)