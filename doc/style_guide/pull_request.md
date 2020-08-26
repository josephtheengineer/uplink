# Pull Request Guidelines

## Updating your fork

    ```shell
    git rebase master -i
    git push -f
    ```

# Commit message
> See commit_guidelines.md for more info

The format is <type>: <subject> (#pull request)

Example:

```
feature: add script names to debug log (#82)
```
#### After your pull request is merged

After your pull request is merged, you can safely pull the changes from the main (upstream) repository:

* Check out the master branch:

    ```shell
    git checkout master -f
    ```

* Update your master with the latest upstream version:

    ```shell
    git pull --ff upstream master
    ```
