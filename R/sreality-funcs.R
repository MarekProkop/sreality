add_property <- function(data_path, img_dir, url) {
  if (file.exists(data_path)) {
    properties <- readr::read_rds(data_path)
  } else {
    properties <- create_archive()
    warning(paste0("File ", data_path, "doesn't exist. Creating a new one."))
  }
  id = id_from_url(url)
  stopifnot("Id already exists." = !(id %in% properties$id))
  new_properties <- id |>
    purrr::map_dfr(fetch_prop_info) |>
    dplyr::mutate(status = "init", url = url)
  properties |>
    dplyr::bind_rows(new_properties) |>
    readr::write_rds(data_path)
  new_properties
}

id_from_url <- function(url) {
  stringr::str_extract(url, "\\d+$")
}

update_properties <- function(rds_path) {
  archived_data <- readr::read_rds(rds_path)
  fresh_data <- archived_data |>
    dplyr::pull(id) |>
    unique() |>
    purrr::map_dfr(fetch_prop_info)
  archived_data |>
    dplyr::bind_rows(fresh_data) |>
    readr::write_rds(rds_path)
}

list_properies <- function(rds_path) {
  readr::read_rds(rds_path) |>
    dplyr::group_by(id) |>
    tidyr::fill(location, name, price, description, url, .direction = "down") |>
    dplyr::summarise(
      id = dplyr::first(id),
      status = dplyr::last(status),
      checked_0 = min(checked),
      checked_last = max(checked),
      dur = checked_last - checked_0,
      location = dplyr::last(location),
      name = dplyr::last(name),
      price_0 = dplyr::first(price),
      price_last = dplyr::last(price),
      description = dplyr::last(description),
      url = dplyr::first(url)
    )
}


# Private functions -------------------------------------------------------


create_archive <- function(data_path) {
  tibble::tibble(
    id = character(),
    status = character(),
    checked = as.POSIXct(numeric()),
    location = character(),
    name = character(),
    price = numeric(),
    description = character(),
    url = character()
  )
}

fetch_prop_info <- function(prop_id) {
  base_url <- "https://www.sreality.cz/api/cs/v2/estates/"
  resp <- httr::GET(paste0(base_url, prop_id))
  if (httr::http_error(resp)) {
    if (resp$status_code == 410) {
      return(list(
        id = prop_id,
        status = "gone",
        checked = Sys.time()
      ))
    } else {
      stop(httr::http_status(resp)$message)
    }
  } else {
    json <- jsonlite::fromJSON(httr::content(resp, as = "text", encoding = "utf-8"))
    list(
      id = prop_id,
      status = "live",
      checked = Sys.time(),
      location = json$locality$value,
      name = stringr::str_squish(json$name$value),
      price = json$price_czk$value_raw,
      description = json$meta_description
    )
  }
}

