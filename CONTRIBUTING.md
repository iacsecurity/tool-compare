# Contributing
Anyone can contribute to this repository. The main areas of contribution are:

- Adding An External Tool
- Adding Test Cases
- Updating The Entire Repository

---

## Getting Set Up
Before running any of the steps, set up the repository locall.

First clone the repository:
```bash
git clone https://github.com/iacsecurity/tool-compare.git
```

Make sure you have docker installed:
```bash
docker ps
```

---

## Adding An External Tool
* Adding an additional tool - simply add the tool to this readme and the `run_all_tools.sh` script. Then,
execute that script and add all of its results as part of your PR. That's it, you're good to go.

---

## Adding Test Cases
* Adding test-cases - you can add the test case in the correct spot in the tree under [test-cases](/test-cases)
and run the `run_all_tools.sh` script against it. Make sure to include all of the tools' results as part of your PR.

---

## Updating The Entire Repository
To update the entire repository, first create a new branch:

```bash
git checkout -b update/january-2020
```

And then clear all result files from the repository:

```bash
make clear-all-results
```

Use the make run-all command to re-run all tools and regenerate results. This step will take some time.

```bash
make run-all
```

When complete, generate the readme tables by using the following command:
```bash
make generate-readme
```

Finally, commit your changes to the branch, push it, and open a pull request for review.
