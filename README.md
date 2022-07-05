
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sreality

<!-- badges: start -->

<!-- badges: end -->

With the functions from this repository you can create your personal
database of property offers from the Sreality website, update their
status and analyse their history. You need some knowledge of R to do
this.

## How to use

1.  Clone this repo, or create a new project in RStudio and copy the R
    folder.
2.  Create subfolders `data` and `images`.

### Load packages and functions

``` r
library(tidyverse)
library(httr)
library(jsonlite)

source("R/sreality-funcs.R")
```

### Add property

Adds the property with the given URL to the `data/my_properties.rds`
file. If a property with the given id already exists in the file, an
error will occur.

``` r
add_property(
  data_path = "data/my_properties.rds",
  img_dir = "images",
  url = "https://www.sreality.cz/detail/prodej/dum/rodinny/melnik-melnik-namesti-miru/3960968780"
)
#> Warning in add_property(data_path = "data/my_properties.rds", img_dir =
#> "images", : File data/my_properties.rdsdoesn't exist. Creating a new one.
#> # A tibble: 1 × 8
#>   id         status checked             location  name   price description url  
#>   <chr>      <chr>  <dttm>              <chr>     <chr>  <int> <chr>       <chr>
#> 1 3960968780 init   2022-07-05 13:05:10 náměstí … Prod… 1.30e7 Rodinný dů… http…
```

Adds multiple properties to the `data/my_properties.rds` file. If any
property id already exists in the file, an error will occur.

``` r
add_property(
  data_path = "data/my_properties.rds",
  img_dir = "images",
  url = c(
    "https://www.sreality.cz/detail/prodej/dum/rodinny/vernerice-rychnov-/2752723036",
    "https://www.sreality.cz/detail/prodej/dum/rodinny/tabor-tabor-provaznicka/3936430428"
  )
)
#> # A tibble: 2 × 8
#>   id         status checked             location  name   price description url  
#>   <chr>      <chr>  <dttm>              <chr>     <chr>  <int> <chr>       <chr>
#> 1 2752723036 init   2022-07-05 13:05:10 Verneřic… Prod… 5.79e6 Rodinný dů… http…
#> 2 3936430428 init   2022-07-05 13:05:10 Provazni… Prod… 9.7 e6 Rodinný dů… http…
```

### Update properties

Fetches all properties in the `data/my_properties.rds` file from
Sreality and appends their current data to the end of the file.

``` r
update_properties(rds_path = "data/my_properties.rds")
```

### List archived data

``` r
read_rds("data/my_properties.rds")
#> # A tibble: 6 × 8
#>   id         status checked             location  name   price description url  
#>   <chr>      <chr>  <dttm>              <chr>     <chr>  <dbl> <chr>       <chr>
#> 1 3960968780 init   2022-07-05 13:05:10 náměstí … Prod… 1.30e7 Rodinný dů… http…
#> 2 2752723036 init   2022-07-05 13:05:10 Verneřic… Prod… 5.79e6 Rodinný dů… http…
#> 3 3936430428 init   2022-07-05 13:05:10 Provazni… Prod… 9.7 e6 Rodinný dů… http…
#> 4 3960968780 live   2022-07-05 13:05:11 náměstí … Prod… 1.30e7 Rodinný dů… <NA> 
#> 5 2752723036 live   2022-07-05 13:05:11 Verneřic… Prod… 5.79e6 Rodinný dů… <NA> 
#> 6 3936430428 live   2022-07-05 13:05:11 Provazni… Prod… 9.7 e6 Rodinný dů… <NA>
```

Displays the current state of all properties in the
`data/my_properties.rds` file.

``` r
list_properies("data/my_properties.rds")
#> # A tibble: 3 × 11
#>   id         status checked_0           checked_last        dur   location name 
#>   <chr>      <chr>  <dttm>              <dttm>              <drt> <chr>    <chr>
#> 1 2752723036 live   2022-07-05 13:05:10 2022-07-05 13:05:11 1.03… Verneři… Prod…
#> 2 3936430428 live   2022-07-05 13:05:10 2022-07-05 13:05:11 1.01… Provazn… Prod…
#> 3 3960968780 live   2022-07-05 13:05:10 2022-07-05 13:05:11 1.11… náměstí… Prod…
#> # … with 4 more variables: price_0 <dbl>, price_last <dbl>, description <chr>,
#> #   url <chr>
```

You can filter the previous dataframe by status (only valid: `status
%in% c("init", "live")` or only removed: `status == "gone"`), by price
change (`price_last != price_0`), etc.

## To-do

Maybe I’ll add those features some day:

  - Downloading preview images of the property.
  - Shiny app to make it more user-friendly.
