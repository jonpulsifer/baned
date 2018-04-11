# baned

[`bane`](https://github.com/genuinetools/bane) is an AppArmor profile generator for docker containers. I needed AppArmor profiles on my GKE nodes.


## Gotcha

CronJob or runOnce DaemonSets do not exist in Kubernetes yet ref https://github.com/kubernetes/kubernetes/issues/36601 so this is what I think an elegant solution in the interim looks like.

## Lets Go :rocket:

There are three containers used in the DaemonSet example found in `k8s/`

1. `k8s.gcr.io/git-sync`: as expected, syncs a git repo to a volume
1. `jonpulsifer/bane`: does a `find /profile/dir/ -type f -name "*.toml" -exec bane {} \;`
    - see `Dockerfile` in the repo root
    - tl;dr `FROM alpine:edge` + `apk add apparmor@testing` + `COPY --from-builder=/go/bin/bane /sbin/`
1. `k8s.gcr.io/pause`: sleep ([read more here](https://www.ianlewis.org/en/almighty-pause-container))

So, the git container downloads some `.toml` files that `bane` will parse. `bane` parses them, then the DaemonSet sleeps to not consume cluster resources.

This enables continuous delivery of apparmor profiles to all your kubernetes nodes, deploys trigger a rolling update and the new profiles are applied.

## GOTCHA AGAIN

**This literally calls apparmor_parser a bunch of times so PR https://github.com/genuinetools/bane for $feature**
