library(tidyverse)

#Fixing the dataset.
header <- read_lines("games.csv", n_max = 1) |>
  str_replace("DiscountDLC count", "Discount,DLC count") |>
  str_split(",") |>
  unlist()

games <- read_csv("games.csv", skip = 1, col_names = header) |>
  rename_with(~ str_to_lower(str_replace_all(.x, " ", "_")))

glimpse(games)

#Keeping what we need for out analysis and removing the rest
gamesClean <- games |>
  select(appid, name, release_date, estimated_owners, price, discount, 
           positive, negative, windows, mac, linux, dlc_count, genres,
           median_playtime_forever) |>
  mutate(
    totalReviews = positive + negative,
    reviewScore = positive/totalReviews,
    playtimeHours = median_playtime_forever/60,
    isDiscounted = discount>0,
    isFree = price == 0,
    releaseDate = parse_date_time(release_date, orders = c("mdy", "my")),
    releaseYear = year(releaseDate),
    releaseMonth = month(releaseDate, label=TRUE)
  ) |>
  filter(totalReviews >= 50)

nrow(gamesClean)
sum(is.na(gamesClean$release_date))
glimpse(gamesClean)

