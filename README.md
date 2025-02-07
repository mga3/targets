# targets

🎯🎯

Concept builds - pipeline setups and functions I have found useful with the {targets} package.

## Get Started - set up and `{renv}`

In RStudio:

1.  [Install Git](https://git-scm.com/downloads/win)

2.  Ensure RStudio can 'see' where Git is installed. Click 'Tools' -\> 'Global Options' -\> 'Git/SVN' -\> 'Git executable:' and make sure the path listed there is pointing to the git.exe you just installed.

3.  Top right - create a 'New Project' -\> 'Version Control' -\> 'Git' -\> 'Repository URL' and paste <https://github.com/mga3/targets.git>. This automatically opens the .Rproj project, which manages this projects' settings and allows for a consistent working environment with multiple collaborators (sets working directory, Git version control and restoring your previous session).

4.  Note, you can also clone the repository with

``` bash
git clone https://github.com/mga3/targets.git

cd targets
```

This project uses `{renv}` for dependency management to ensure reproducibility.
Download the required packages from _repositories_ with `install.packages()`.

See setup_dependencies.qmd for a guide to getting set up. Run `.libPaths()` to 
see your libraries and check if you have {renv} for this project set up already.




