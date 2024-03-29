#!/bin/bash
set -euo pipefail

CMD=$0

function usage {
    cat <<EOU
    Usage:
    $CMD REGISTRY_BASE_URL ACTION [OPTIONS..]

    Actions:
    - list               list repos
    - list REPO          list tags for repo
    - delete REPO TAG    delete tag for repo
    Example:
    List all repos
        /$ $CMD https://registry.my.domain list
    List tags for one repo
        /$ $CMD https://registry.my.domain list some-repo
    Delete tag for a repo
        /$ $CMD https://registry.my.domain delete some-repo
EOU
    exit 1
}

[ $# -lt 2 ] && usage

set +e
PROTO="$(echo $1 | grep :// | sed -e's,^\(.*://\).*,\1,g')"
set -e

[ -z "$PROTO" ] && >&2 echo "ERROR: Must have protocol in registry url" && usage

# remove the protocol
REG="$(echo ${1/$PROTO/})"
shift
ACTION="$1"
shift

CREDS="Authorization: Basic $(jq -r '.auths."'$REG'".auth' < ~/.docker/config.json)"

case "$ACTION" in
    list)
        if [ $# -eq 1 ]; then
            repo=${1}
            if [ -n "$repo" ]; then
                curl -k -s --header "$CREDS" $PROTO$REG/v2/$repo/tags/list | jq -r '.tags|.[]'
            fi
        else
            curl -k -s --header "$CREDS" $PROTO$REG/v2/_catalog | jq -r '.repositories|.[]'
        fi

        ;;
    delete)
        repo=$1
        tag=$2
        digest=$(curl -k -v -s --header "$CREDS" -H "Accept:application/vnd.docker.distribution.manifest.v2+json" $PROTO$REG/v2/$repo/manifests/$tag 2>&1 |grep "< Docker-Content-Digest:"|awk '{print $3}')
        digest=${digest//[$'\t\r\n']}
        echo "DIGEST: $digest"
        result=$(curl -k --header "$CREDS"  -s -o /dev/null -w "%{http_code}" -H "Accept:application/vnd.docker.distribution.manifest.v2+json" -X DELETE "$PROTO$REG/v2/$repo/manifests/$digest")
        if [ $result -eq 202 ]; then
            echo "Successfully deleted"
            exit 0
        else
            echo "Failed to delete"
            exit 3
        fi
        ;;
esac