#!/usr/bin/env -S bash -e -o pipefail -O inherit_errexit

usage() {
cat <<EOF
Usage: $(basename "$0") [ options ] arguments

Options:
    -h|--help                   Show this help
    -n|--dry-run                Trial run, no changes made

EOF
}
log_msg() {
    echo -e "\033[0;32m$1\033[0m"
}
err_msg() {
    echo -e "\033[1;31mEE:\033[0m $1" >&2
}
catch_error() {
    err_msg "exit status $1 on line $2"
    exit 1
}
trap 'catch_error $? $LINENO' ERR
clean_exit() {
    log_msg "Terminating script at: `date`"
}
trap clean_exit EXIT
catch_sigint() {
    log_msg "\nTerminated by user at `date`\nbye bye..."
    exit 0
}
trap catch_sigint SIGINT

OPTS=$(getopt --options hn --long help,dry-run --name "$0" -- "$@")
[ $? == 0 ] && eval set -- "$OPTS" || { echo "failed to parse options.. exiting" >&2 ; exit 1 ; }

while true ; do
    case $1 in
        -h|--help) usage
            shift
            exit
            ;;
        -n|--dry-run) is_dryrun=1
            shift
            ;;
        --) shift
            break
            ;;
        -?*) err_msg "unkown option: $2"
            shift
            exit 1
            ;;
        *) break
            ;;
    esac
done
shift $((OPTIND-1))
args=("${@}")

