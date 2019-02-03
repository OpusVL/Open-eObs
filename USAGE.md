# Usage

```sh
make all # Default open-eObs from repo
```

Options:
```sh
make repo # setup open-eObs repo
make branch # checkout branch
make clean # remove open-eObs repo
make build # build open-eObs container
make run # run open-eObs services
make stop # stop open-eObs services
make logs # review open-eObs logs
```

# Debug

To test/debug a PR:
```sh
pr=48 make debug-pr debug-build debug-run
make debug-logs
```

To test/debug a branch:
```sh
branch=new_feature make debug-branch debug-build debug-run
make debug-logs
```

options:
```sh
branch=XXX make debug-branch # checkout and debug a branch
pr=XXX make debug-pr # checkout and debug a PR
make debug-build # build open-eObs container
make debug-run # run open-eObs services
make debug-down # down open-eObs services
make debug-logs # review open-eObs logs
make debug-pgdump # dump databases
```
