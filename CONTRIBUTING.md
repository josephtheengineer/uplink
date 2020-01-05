This project follows [Agis' Git Style Guide](https://github.com/agis/git-style-guide/blob/master/CONTRIBUTING.md) 
and [Godot Engine's CONTRIBUTING.md](https://github.com/godotengine/godot/edit/master/CONTRIBUTING.md)

# How to contribute efficiently

Sections covered in this file:

* [Reporting bugs or proposing features](#reporting-bugs-or-proposing-features)
* [Contributing pull requests](#contributing-pull-requests)
* [Contributing to Godot's translation](#contributing-to-godots-translation)
* [Communicating with developers](#communicating-with-developers)

**Please read the first section before reporting a bug!**

## Reporting bugs or proposing features

The golden rule is to **always open *one* issue for *one* bug**. If you notice
several bugs and want to report them, make sure to create one new issue for
each of them.

Everything referred to hereafter as "bug" also applies for feature requests.

If you are reporting a new issue, you will make our life much simpler (and the
fix come much sooner) by following these guidelines:

#### Search first in the existing database

Issues are often reported several times by various users. It's a good practice
to **search first** in the issues database before reporting your issue. If you
don't find a relevant match or if you are unsure, don't hesitate to **open a
new issue**. The bugsquad will handle it from there if it's a duplicate.

#### Specify the platform

Eden: Universe Builder runs on a large variety of platforms and operating systems and devices.
If you believe your issue is device/platform dependent (for example if it is
related to the rendering, crashes or compilation errors), please specify:
* Operating system
* Device (including architecture, e.g. x86, x86_64, arm, etc.)
* GPU model (and driver in use if you know it)

#### Specify steps to reproduce

Many bugs can't be reproduced unless specific steps are taken. Please **specify
the exact steps** that must be taken to reproduce the condition, and try to
keep them as minimal as possible.

## Contributing pull requests

If you want to add new game functionalities, please make sure that:

* You talked to other developers on how to implement it best (on either
  communication channel, and maybe in a GitHub issue first before making your
  PR).
* Even if it does not get merged, your PR is useful for future work by another
  developer.

Similar rules can be applied when contributing bug fixes - it's always best to
discuss the implementation in the bug report first if you are not 100% about
what would be the best fix.

#### Be nice to the git history

Try to make simple PRs that handle one specific topic. Just like for reporting
issues, it's better to open 3 different PRs that each address a different issue
than one big PR with three commits.

When updating your fork with upstream changes, please use ``git pull --rebase``
to avoid creating "merge commits". Those commits unnecessarily pollute the git
history when coming from PRs.

Also try to make commits that bring the engine from one stable state to another
stable state, i.e. if your first commit has a bug that you fixed in the second
commit, try to merge them together before making your pull request (see ``git
rebase -i`` and relevant help about rebasing or amending commits on the
Internet).

This git style guide has some good practices to have in mind:
[Git Style Guide](https://github.com/agis-/git-style-guide)




##### Git Style Guide

This is a Git Style Guide inspired by [*How to Get Your Change Into the Linux
Kernel*](https://kernel.org/doc/html/latest/process/submitting-patches.html),
the [git man pages](http://git-scm.com/doc) and various practices popular
among the community.

Translations are available in the following languages:

* [Chinese (Simplified)](https://github.com/aseaday/git-style-guide)
* [Chinese (Traditional)](https://github.com/JuanitoFatas/git-style-guide)
* [French](https://github.com/pierreroth64/git-style-guide)
* [German](https://github.com/runjak/git-style-guide)
* [Greek](https://github.com/grigoria/git-style-guide)
* [Japanese](https://github.com/objectx/git-style-guide)
* [Korean](https://github.com/ikaruce/git-style-guide)
* [Portuguese](https://github.com/guylhermetabosa/git-style-guide)
* [Russian](https://github.com/alik0211/git-style-guide)
* [Spanish](https://github.com/jeko2000/git-style-guide)
* [Thai](https://github.com/zondezatera/git-style-guide)
* [Turkish](https://github.com/CnytSntrk/git-style-guide)
* [Ukrainian](https://github.com/denysdovhan/git-style-guide)

If you feel like contributing, please do so! Fork the project and open a pull
request.

##### Table of contents

1. [Branches](#branches)
2. [Commits](#commits)
  1. [Messages](#messages)
3. [Merging](#merging)
4. [Misc.](#misc)

###### Branches

* Choose *short* and *descriptive* names:

  ```shell
  # good
  $ git checkout -b oauth-migration

  # bad - too vague
  $ git checkout -b login_fix
  ```

* Identifiers from corresponding tickets in an external service (eg. a GitHub
  issue) are also good candidates for use in branch names. For example:

  ```shell
  # GitHub issue #15
  $ git checkout -b issue-15
  ```

* Use *hyphens* to separate words.

* When several people are working on the *same* feature, it might be convenient
  to have *personal* feature branches and a *team-wide* feature branch.
  Use the following naming convention:

  ```shell
  $ git checkout -b feature-a/master # team-wide branch
  $ git checkout -b feature-a/maria  # Maria's personal branch
  $ git checkout -b feature-a/nick   # Nick's personal branch
  ```

  Merge at will the personal branches to the team-wide branch (see ["Merging"](#merging)).
  Eventually, the team-wide branch will be merged to "master".

* Delete your branch from the upstream repository after it's merged, unless
  there is a specific reason not to.

  Tip: Use the following command while being on "master", to list merged
  branches:

  ```shell
  $ git branch --merged | grep -v "\*"
  ```

###### Commits

* Each commit should be a single *logical change*. Don't make several
  *logical changes* in one commit. For example, if a patch fixes a bug and
  optimizes the performance of a feature, split it into two separate commits.

  *Tip: Use `git add -p` to interactively stage specific portions of the
  modified files.*

* Don't split a single *logical change* into several commits. For example,
  the implementation of a feature and the corresponding tests should be in the
  same commit.

* Commit *early* and *often*. Small, self-contained commits are easier to
  understand and revert when something goes wrong.

* Commits should be ordered *logically*. For example, if *commit X* depends
  on changes done in *commit Y*, then *commit Y* should come before *commit X*.

Note: While working alone on a local branch that *has not yet been pushed*, it's
fine to use commits as temporary snapshots of your work. However, it still
holds true that you should apply all of the above *before* pushing it.

####### Messages

* Use the editor, not the terminal, when writing a commit message:

  ```shell
  # good
  $ git commit

  # bad
  $ git commit -m "Quick fix"
  ```

  Committing from the terminal encourages a mindset of having to fit everything
  in a single line which usually results in non-informative, ambiguous commit
  messages.

* The summary line (ie. the first line of the message) should be
  *descriptive* yet *succinct*. Ideally, it should be no longer than
  *50 characters*. It should be capitalized and written in imperative present
  tense. It should not end with a period since it is effectively the commit
  *title*:

  ```shell
  # good - imperative present tense, capitalized, fewer than 50 characters
  Mark huge records as obsolete when clearing hinting faults

  # bad
  fixed ActiveModel::Errors deprecation messages failing when AR was used outside of Rails.
  ```

* After that should come a blank line followed by a more thorough
  description. It should be wrapped to *72 characters* and explain *why*
  the change is needed, *how* it addresses the issue and what *side-effects*
  it might have.

  It should also provide any pointers to related resources (eg. link to the
  corresponding issue in a bug tracker):

  ```text
  Short (50 chars or fewer) summary of changes

  More detailed explanatory text, if necessary. Wrap it to
  72 characters. In some contexts, the first
  line is treated as the subject of an email and the rest of
  the text as the body.  The blank line separating the
  summary from the body is critical (unless you omit the body
  entirely); tools like rebase can get confused if you run
  the two together.

  Further paragraphs come after blank lines.

  - Bullet points are okay, too

  - Use a hyphen or an asterisk for the bullet,
    followed by a single space, with blank lines in
    between

  The pointers to your related resources can serve as a footer
  for your commit message. Here is an example that is referencing
  issues in a bug tracker:

  Resolves: #56, #78
  See also: #12, #34

  Source http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
  ```

  Ultimately, when writing a commit message, think about what you would need
  to know if you run across the commit in a year from now.

* If a *commit A* depends on *commit B*, the dependency should be
  stated in the message of *commit A*. Use the SHA1 when referring to
  commits.

  Similarly, if *commit A* solves a bug introduced by *commit B*, it should
  also be stated in the message of *commit A*.

* If a commit is going to be squashed to another commit use the `--squash` and
  `--fixup` flags respectively, in order to make the intention clear:

  ```shell
  $ git commit --squash f387cab2
  ```

  *(Tip: Use the `--autosquash` flag when rebasing. The marked commits will be
  squashed automatically.)*

###### Merging

* **Do not rewrite published history.** The repository's history is valuable in
  its own right and it is very important to be able to tell *what actually
  happened*. Altering published history is a common source of problems for
  anyone working on the project.

* However, there are cases where rewriting history is legitimate. These are
  when:

  * You are the only one working on the branch and it is not being reviewed.

  * You want to tidy up your branch (eg. squash commits) and/or rebase it onto
    the "master" in order to merge it later.

  That said, *never rewrite the history of the "master" branch* or any other
  special branches (ie. used by production or CI servers).

* Keep the history *clean* and *simple*. *Just before you merge* your branch:

    1. Make sure it conforms to the style guide and perform any needed actions
       if it doesn't (squash/reorder commits, reword messages etc.)

    2. Rebase it onto the branch it's going to be merged to:

       ```shell
       [my-branch] $ git fetch
       [my-branch] $ git rebase origin/master
       # then merge
       ```

       This results in a branch that can be applied directly to the end of the
       "master" branch and results in a very simple history.

       *(Note: This strategy is better suited for projects with short-running
       branches. Otherwise it might be better to occassionally merge the
       "master" branch instead of rebasing onto it.)*

* If your branch includes more than one commit, do not merge with a
  fast-forward:

  ```shell
  # good - ensures that a merge commit is created
  $ git merge --no-ff my-branch

  # bad
  $ git merge my-branch
  ```

###### Misc.

* There are various workflows and each one has its strengths and weaknesses.
  Whether a workflow fits your case, depends on the team, the project and your
  development procedures.

  That said, it is important to actually *choose* a workflow and stick with it.

* *Be consistent.* This is related to the workflow but also expands to things
  like commit messages, branch names and tags. Having a consistent style
  throughout the repository makes it easy to understand what is going on by
  looking at the log, a commit message etc.

* *Test before you push.* Do not push half-done work.

* Use [annotated tags](https://git-scm.com/book/en/v2/Git-Basics-Tagging#_annotated_tags)
  for marking releases or other important points in the history. Prefer
  [lightweight tags](https://git-scm.com/book/en/v2/Git-Basics-Tagging#_lightweight_tags)
  for personal use, such as to bookmark commits for future reference.

* Keep your repositories at a good shape by performing maintenance tasks
  occasionally:

  * [`git-gc(1)`](http://git-scm.com/docs/git-gc)
  * [`git-prune(1)`](http://git-scm.com/docs/git-prune)
  * [`git-fsck(1)`](http://git-scm.com/docs/git-fsck)

##### License

![cc license](http://i.creativecommons.org/l/by/4.0/88x31.png)

This work is licensed under a [Creative Commons Attribution 4.0
International license](https://creativecommons.org/licenses/by/4.0/).

##### Credits

Agis Anastasopoulos / [@agisanast](https://twitter.com/agisanast) / http://agis.io
... and [contributors](https://github.com/agis-/git-style-guide/graphs/contributors)!



See our [PR workflow](http://docs.godotengine.org/en/latest/community/contributing/pr_workflow.html)
documentation for tips on using Git, amending commits and rebasing branches.

#### Format your commit logs with readability in mind

The way you format your commit logs is quite important to ensure that the
commit history and changelog will be easy to read and understand. A git commit
log is formatted as a short title (first line) and an extended description
(everything after the first line and an empty separation line).

The short title is the most important part, as it is what will appear in the
`shortlog` changelog (one line per commit, so no description shown) or in the
GitHub interface unless you click the "expand" button. As the name tells it,
try to keep that first line relatively short (ideally <= 50 chars, though it's
rare to be able to tell enough in so few characters, so you can go a bit
higher) - it should describe what the commit does globally, while details would
go in the description. Typically, if you can't keep the title short because you
have too much stuff to mention, it means that you should probably split your
changes in several commits :)

Here's an example of a well-formatted commit log (note how the extended
description is also manually wrapped at 80 chars for readability):

```
Prevent French fries carbonization by fixing heat regulation

When using the French fries frying module, Godot would not regulate the heat
and thus bring the oil bath to supercritical liquid conditions, thus causing
unwanted side effects in the physics engine.

By fixing the regulation system via an added binding to the internal feature,
this commit now ensures that Godot will not go past the ebullition temperature
of cooking oil under normal atmospheric conditions.

Fixes #1789, long live the Realm!
```

*Note:* When using the GitHub online editor (or worse, the drag and drop
feature), *please* edit the commit title to something meaningful. Commits named
"Update my_file.cpp" will not be accepted.

## Communicating with developers

The Eden community has [many communication
channels](josephtheengineer.ddns.net/eden), some used more for user-level
discussions and support, others more for development discussions.

To communicate with developers (e.g. to discuss a feature you want to implement
or a bug you want to fix), the following channels can be used:
- [Git issues](josephtheengineer.ddns.net/eden): If there is an
  existing issue about a topic you want to discuss, just add a comment to it -
  all developers watch the repository and will get an email notification. You
  can also create a new issue - please keep in mind to create issues only to
  discuss quite specific points about the development, and not general user
  feedback or support requests.
- [#eden IRC channel on
  josephtheengineer.ddns.net](josephtheengineer.ddns.net): You will
  find most core developers there, so it's the go-to channel for direct chat
  about Eden Universe Builder development. Feel free to start discussing something there
  to get some early feedback before writing up a detailed proposal in a GitHub
  issue.
- [eden@josephtheengineer.ddns.net mailing
  list](josephtheengineer.ddns.net/eden): Mailing list
  for Eden developers to reach people directly in their
  mailbox and used primarily to announce news.
