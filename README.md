

## Package {dbda3}

Welcome to the homepage for the dbda3 package. This is an R package
supporting the third edition of *Doing Bayesian Data Analysis* (order [here](https://www.amazon.com/Doing-Bayesian-Data-Analysis-tidyverse-ebook/dp/B0F93CXTRL)). The
dbda3 package provides a variety of convenience functions supporting
Bayesian data analysis, with an emphasis on a tidyverse-oriented
workflow, and on models fit with the brms package.

## Installation

The dbda3 package is not on CRAN, and we do have plans to make it
available on CRAN for the foreseeable future. You can install the dbda3
package directly from its [GitHub
repository](https://github.com/ASKurz/dbda3). Just execute this code in
your R console.

``` r
if (!requireNamespace("devtools")) install.packages("devtools")
devtools::install_github("ASKurz/dbda3")
```

The first line of the code checks whether you already have the devtools
package on your computer, and installs that package if you do not. We
first need the devtools package so we can access its `install_github()`
function. Then in the second line, we use the `install_github()`
function to install dbda3 from GitHub.

For newer R users, you may see some red-font output in your console when
installing devtools along the lines of:

``` default
Loading required namespace: devtools
Failed with error:  ‘there is no package called ‘devtools’’
trying URL 'https://cran.rstudio.com/bin/macosx/big-sur-arm64/contrib/4.4/devtools_2.4.5.tgz'
Content type 'application/x-gzip' length 434637 bytes (424 KB)
==================================================
downloaded 424 KB

The downloaded binary packages are in
    /var/folders/ff/pyxx17ws0l38sr420ztg3rdw0000gn/T//RtmpvTk9jU/downloaded_packages
```

This is normal, and generally does not require anything else from your
end. In a similar way, you’ll also likely see a bunch of text output in
your console after executing `devtools::install_github("ASKurz/dbda3")`.
If it ends in line reading `* DONE (dbda3)`, congratulations, you’ve
downloaded the dbda3 package!

When executing, some users may see a few lines in their console that
looks similar to

``` default
Using GitHub PAT from the git credential store.
Downloading GitHub repo ASKurz/dbda3@HEAD
These packages have more recent versions available.
It is recommended to update all of them.
Which would you like to update?

1: All                            
2: CRAN packages only             
3: None                           
4: pillar (1.9.0 -> 1.10.0) [CRAN]
5: gtable (0.3.5 -> 0.3.6 ) [CRAN]

Enter one or more numbers, or an empty line to skip updates: 
```

but possibly with different options for numbers 4 and greater. This is
giving you the option to update all or some of the packages that support
dbda3. We recommend selecting `1` by entering that number in your
console, and then executing (hitting the enter/return key).

After installing the dbda3 package, it’s a good idea to restart R, or
RStudio if you use that interface (which we generally recommend). Then
in a fresh R (or RStudio) session, you can now use the dbda3 package by
executing the following in your console.

``` r
library(dbda3)
```

In addition to the documentation on this website, you can also learn
about the dbda3 package by executing the following in your console. It
should give you a list of the functions, as well as technical
documentation for the package.

``` r
help(package = "dbda3")
```
