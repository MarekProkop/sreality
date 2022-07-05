
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
#> 1 3960968780 init   2022-07-05 23:23:16 náměstí … Prod… 1.30e7 Rodinný dů… http…
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
#> 1 2752723036 init   2022-07-05 23:23:17 Verneřic… Prod… 5.79e6 Rodinný dů… http…
#> 2 3936430428 init   2022-07-05 23:23:17 Provazni… Prod… 9.7 e6 Rodinný dů… http…
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
#> 1 3960968780 init   2022-07-05 23:23:16 náměstí … Prod… 1.30e7 Rodinný dů… http…
#> 2 2752723036 init   2022-07-05 23:23:17 Verneřic… Prod… 5.79e6 Rodinný dů… http…
#> 3 3936430428 init   2022-07-05 23:23:17 Provazni… Prod… 9.7 e6 Rodinný dů… http…
#> 4 3960968780 live   2022-07-05 23:23:18 náměstí … Prod… 1.30e7 Rodinný dů… <NA> 
#> 5 2752723036 live   2022-07-05 23:23:18 Verneřic… Prod… 5.79e6 Rodinný dů… <NA> 
#> 6 3936430428 live   2022-07-05 23:23:18 Provazni… Prod… 9.7 e6 Rodinný dů… <NA>
```

#### Current state of properties

Displays the current state of all properties in the
`data/my_properties.rds` file.

``` r
list_properies("data/my_properties.rds")
#> # A tibble: 3 × 11
#>   id         status checked_0           checked_last        dur   location name 
#>   <chr>      <chr>  <dttm>              <dttm>              <drt> <chr>    <chr>
#> 1 2752723036 live   2022-07-05 23:23:17 2022-07-05 23:23:18 1.07… Verneři… Prod…
#> 2 3936430428 live   2022-07-05 23:23:17 2022-07-05 23:23:18 0.97… Provazn… Prod…
#> 3 3960968780 live   2022-07-05 23:23:16 2022-07-05 23:23:18 1.22… náměstí… Prod…
#> # … with 4 more variables: price_0 <dbl>, price_last <dbl>, description <chr>,
#> #   url <chr>
```

#### List of properties using the {gt} package

You can filter the previous dataframe by status (only valid: `status
%in% c("init", "live")` or only removed: `status == "gone"`), by price
change (`price_last != price_0`), etc.

``` r
list_properies("data/my_properties.rds") |> 
  mutate(
    name = paste0("[", name, "](", url, ")"),
    name = map(name, gt::md)
  ) |> 
  select(name, location, price_last) |> 
  gt::gt() |> 
  gt::cols_label(price_last = "price") |> 
  gt::fmt_number(price_last, decimals = 0, suffixing = "K")
```

<div id="kznytzkcyz" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#kznytzkcyz .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#kznytzkcyz .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#kznytzkcyz .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#kznytzkcyz .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#kznytzkcyz .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#kznytzkcyz .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#kznytzkcyz .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#kznytzkcyz .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#kznytzkcyz .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#kznytzkcyz .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#kznytzkcyz .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#kznytzkcyz .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#kznytzkcyz .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#kznytzkcyz .gt_from_md > :first-child {
  margin-top: 0;
}

#kznytzkcyz .gt_from_md > :last-child {
  margin-bottom: 0;
}

#kznytzkcyz .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#kznytzkcyz .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#kznytzkcyz .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#kznytzkcyz .gt_row_group_first td {
  border-top-width: 2px;
}

#kznytzkcyz .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#kznytzkcyz .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#kznytzkcyz .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#kznytzkcyz .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#kznytzkcyz .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#kznytzkcyz .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#kznytzkcyz .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#kznytzkcyz .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#kznytzkcyz .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#kznytzkcyz .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#kznytzkcyz .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#kznytzkcyz .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#kznytzkcyz .gt_left {
  text-align: left;
}

#kznytzkcyz .gt_center {
  text-align: center;
}

#kznytzkcyz .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#kznytzkcyz .gt_font_normal {
  font-weight: normal;
}

#kznytzkcyz .gt_font_bold {
  font-weight: bold;
}

#kznytzkcyz .gt_font_italic {
  font-style: italic;
}

#kznytzkcyz .gt_super {
  font-size: 65%;
}

#kznytzkcyz .gt_two_val_uncert {
  display: inline-block;
  line-height: 1em;
  text-align: right;
  font-size: 60%;
  vertical-align: -0.25em;
  margin-left: 0.1em;
}

#kznytzkcyz .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#kznytzkcyz .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#kznytzkcyz .gt_slash_mark {
  font-size: 0.7em;
  line-height: 0.7em;
  vertical-align: 0.15em;
}

#kznytzkcyz .gt_fraction_numerator {
  font-size: 0.6em;
  line-height: 0.6em;
  vertical-align: 0.45em;
}

#kznytzkcyz .gt_fraction_denominator {
  font-size: 0.6em;
  line-height: 0.6em;
  vertical-align: -0.05em;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">name</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">location</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">price</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td class="gt_row gt_center"><a href="https://www.sreality.cz/detail/prodej/dum/rodinny/vernerice-rychnov-/2752723036">Prodej rodinného domu 208 m², pozemek 2 069 m²</a></td>
<td class="gt_row gt_left">Verneřice - Rychnov, okres Děčín</td>
<td class="gt_row gt_right">5,790K</td></tr>
    <tr><td class="gt_row gt_center"><a href="https://www.sreality.cz/detail/prodej/dum/rodinny/tabor-tabor-provaznicka/3936430428">Prodej rodinného domu 231 m², pozemek 107 m²</a></td>
<td class="gt_row gt_left">Provaznická, Tábor</td>
<td class="gt_row gt_right">9,700K</td></tr>
    <tr><td class="gt_row gt_center"><a href="https://www.sreality.cz/detail/prodej/dum/rodinny/melnik-melnik-namesti-miru/3960968780">Prodej rodinného domu 150 m², pozemek 250 m²</a></td>
<td class="gt_row gt_left">náměstí Míru, Mělník</td>
<td class="gt_row gt_right">12,990K</td></tr>
  </tbody>
  
  
</table>
</div>

## To-do

Maybe I’ll add those features some day:

  - Downloading preview images of the property.
  - Shiny app to make it more user-friendly.
