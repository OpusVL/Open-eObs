# Usage

```sh
make run
```

Default options:
```sh
make run # run open-eObs containers
make stop # stop open-eObs containers
make clean # remove open-eObs repo
make repo # setup open-eObs repo
make branch # checkout branch
make build # build open-eObs container
make logs # review logs
```

Debug options:
```sh
make debug-run # run open-eObs containers
make debug-build # build open-eObs containers
make debug-down # down open-eObs containers
make debug-logs # review logs
make debug-pgdump # dump postgres db
branch=XXX make debug-branch # debug a PR
pr=XXX make debug-pr # debug a branch
```
