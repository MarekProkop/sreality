
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
#> 1 3960968780 init   2022-07-05 23:41:23 náměstí … Prod… 1.30e7 Rodinný dů… http…
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
#> 1 2752723036 init   2022-07-05 23:41:23 Verneřic… Prod… 5.79e6 Rodinný dů… http…
#> 2 3936430428 init   2022-07-05 23:41:24 Provazni… Prod… 9.7 e6 Rodinný dů… http…
```

### Update properties

Fetches all properties in the `data/my_properties.rds` file from
Sreality and appends their current data to the end of the file.

``` r
update_properties(rds_path = "data/my_properties.rds")
```

### List archived data

#### Full content of the archive

``` r
read_rds("data/my_properties.rds")
#> # A tibble: 6 × 8
#>   id         status checked             location  name   price description url  
#>   <chr>      <chr>  <dttm>              <chr>     <chr>  <dbl> <chr>       <chr>
#> 1 3960968780 init   2022-07-05 23:41:23 náměstí … Prod… 1.30e7 Rodinný dů… http…
#> 2 2752723036 init   2022-07-05 23:41:23 Verneřic… Prod… 5.79e6 Rodinný dů… http…
#> 3 3936430428 init   2022-07-05 23:41:24 Provazni… Prod… 9.7 e6 Rodinný dů… http…
#> 4 3960968780 live   2022-07-05 23:41:24 náměstí … Prod… 1.30e7 Rodinný dů… <NA> 
#> 5 2752723036 live   2022-07-05 23:41:25 Verneřic… Prod… 5.79e6 Rodinný dů… <NA> 
#> 6 3936430428 live   2022-07-05 23:41:25 Provazni… Prod… 9.7 e6 Rodinný dů… <NA>
```

#### Current state of properties

Displays the current state of all properties in the
`data/my_properties.rds` file.

``` r
list_properies("data/my_properties.rds")
#> # A tibble: 3 × 11
#>   id         status checked_0           checked_last        dur   location name 
#>   <chr>      <chr>  <dttm>              <dttm>              <drt> <chr>    <chr>
#> 1 2752723036 live   2022-07-05 23:41:23 2022-07-05 23:41:25 1.08… Verneři… Prod…
#> 2 3936430428 live   2022-07-05 23:41:24 2022-07-05 23:41:25 1.08… Provazn… Prod…
#> 3 3960968780 live   2022-07-05 23:41:23 2022-07-05 23:41:24 1.15… náměstí… Prod…
#> # … with 4 more variables: price_0 <dbl>, price_last <dbl>, description <chr>,
#> #   url <chr>
```

You can filter the previous dataframe by status (only valid: `status
%in% c("init", "live")` or only removed: `status == "gone"`), by price
change (`price_last != price_0`), etc.

#### List of properties using the {gt} package

``` r
list_properies("data/my_properties.rds") |> 
  mutate(
    name = paste0("[", name, "](", url, ")"),
    name = map(name, gt::md)
  ) |> 
  select(name, location, price_last) |> 
  gt::gt() |> 
  gt::cols_label(price_last = "price") |> 
  gt::fmt_number(price_last, decimals = 0, suffixing = "K") |> 
  gt::as_raw_html()
```

<table style="font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif; display: table; border-collapse: collapse; margin-left: auto; margin-right: auto; color: #333333; font-size: 16px; font-weight: normal; font-style: normal; background-color: #FFFFFF; width: auto; border-top-style: solid; border-top-width: 2px; border-top-color: #A8A8A8; border-right-style: none; border-right-width: 2px; border-right-color: #D3D3D3; border-bottom-style: solid; border-bottom-width: 2px; border-bottom-color: #A8A8A8; border-left-style: none; border-left-width: 2px; border-left-color: #D3D3D3;">
  
  <thead style="border-top-style: solid; border-top-width: 2px; border-top-color: #D3D3D3; border-bottom-style: solid; border-bottom-width: 2px; border-bottom-color: #D3D3D3; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3;">
    <tr>
      <th style="color: #333333; background-color: #FFFFFF; font-size: 100%; font-weight: normal; text-transform: inherit; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: bottom; padding-top: 5px; padding-bottom: 6px; padding-left: 5px; padding-right: 5px; overflow-x: hidden; text-align: center;" rowspan="1" colspan="1">name</th>
      <th style="color: #333333; background-color: #FFFFFF; font-size: 100%; font-weight: normal; text-transform: inherit; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: bottom; padding-top: 5px; padding-bottom: 6px; padding-left: 5px; padding-right: 5px; overflow-x: hidden; text-align: left;" rowspan="1" colspan="1">location</th>
      <th style="color: #333333; background-color: #FFFFFF; font-size: 100%; font-weight: normal; text-transform: inherit; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: bottom; padding-top: 5px; padding-bottom: 6px; padding-left: 5px; padding-right: 5px; overflow-x: hidden; text-align: right; font-variant-numeric: tabular-nums;" rowspan="1" colspan="1">price</th>
    </tr>
  </thead>
  <tbody style="border-top-style: solid; border-top-width: 2px; border-top-color: #D3D3D3; border-bottom-style: solid; border-bottom-width: 2px; border-bottom-color: #D3D3D3;">
    <tr><td style="padding-top: 8px; padding-bottom: 8px; padding-left: 5px; padding-right: 5px; margin: 10px; border-top-style: solid; border-top-width: 1px; border-top-color: #D3D3D3; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: middle; overflow-x: hidden; text-align: center;"><a href="https://www.sreality.cz/detail/prodej/dum/rodinny/vernerice-rychnov-/2752723036">Prodej rodinného domu 208 m², pozemek 2 069 m²</a></td>
<td style="padding-top: 8px; padding-bottom: 8px; padding-left: 5px; padding-right: 5px; margin: 10px; border-top-style: solid; border-top-width: 1px; border-top-color: #D3D3D3; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: middle; overflow-x: hidden; text-align: left;">Verneřice - Rychnov, okres Děčín</td>
<td style="padding-top: 8px; padding-bottom: 8px; padding-left: 5px; padding-right: 5px; margin: 10px; border-top-style: solid; border-top-width: 1px; border-top-color: #D3D3D3; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: middle; overflow-x: hidden; text-align: right; font-variant-numeric: tabular-nums;">5,790K</td></tr>
    <tr><td style="padding-top: 8px; padding-bottom: 8px; padding-left: 5px; padding-right: 5px; margin: 10px; border-top-style: solid; border-top-width: 1px; border-top-color: #D3D3D3; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: middle; overflow-x: hidden; text-align: center;"><a href="https://www.sreality.cz/detail/prodej/dum/rodinny/tabor-tabor-provaznicka/3936430428">Prodej rodinného domu 231 m², pozemek 107 m²</a></td>
<td style="padding-top: 8px; padding-bottom: 8px; padding-left: 5px; padding-right: 5px; margin: 10px; border-top-style: solid; border-top-width: 1px; border-top-color: #D3D3D3; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: middle; overflow-x: hidden; text-align: left;">Provaznická, Tábor</td>
<td style="padding-top: 8px; padding-bottom: 8px; padding-left: 5px; padding-right: 5px; margin: 10px; border-top-style: solid; border-top-width: 1px; border-top-color: #D3D3D3; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: middle; overflow-x: hidden; text-align: right; font-variant-numeric: tabular-nums;">9,700K</td></tr>
    <tr><td style="padding-top: 8px; padding-bottom: 8px; padding-left: 5px; padding-right: 5px; margin: 10px; border-top-style: solid; border-top-width: 1px; border-top-color: #D3D3D3; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: middle; overflow-x: hidden; text-align: center;"><a href="https://www.sreality.cz/detail/prodej/dum/rodinny/melnik-melnik-namesti-miru/3960968780">Prodej rodinného domu 150 m², pozemek 250 m²</a></td>
<td style="padding-top: 8px; padding-bottom: 8px; padding-left: 5px; padding-right: 5px; margin: 10px; border-top-style: solid; border-top-width: 1px; border-top-color: #D3D3D3; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: middle; overflow-x: hidden; text-align: left;">náměstí Míru, Mělník</td>
<td style="padding-top: 8px; padding-bottom: 8px; padding-left: 5px; padding-right: 5px; margin: 10px; border-top-style: solid; border-top-width: 1px; border-top-color: #D3D3D3; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: middle; overflow-x: hidden; text-align: right; font-variant-numeric: tabular-nums;">12,990K</td></tr>
  </tbody>
  
  
</table>

## To-do

Maybe I’ll add those features some day:

  - Downloading preview images of the property.
  - Shiny app to make it more user-friendly.
