#
# Category reduction based on accumulated density
#

## REFERRING URLs

factor_levels <- length(levels(data$referring_url))

# Sort categories by decreasing order
url_amounts <- sort(table(data$referring_url), decreasing = TRUE)

# Accumulated density
accumulated <- numeric(factor_levels)
total <- sum(!is.na(data$referring_url))
for(i in 1:factor_levels){
    accumulated[i] <- sum(url_amounts[1:i]/total)
}

# Plot
require(ggplot2)
ggplot()+geom_line(aes(x=1:factor_levels,y=accumulated),colour="RED")

# Number of level to keep 90% of  total information
max_level <- which(accumulated >= 0.9)[1]

# Extraction of selected categories names
factor_names <- as.factor(row.names(url_amounts[1:max_level]))

data$referring_url[(!data$referring_url %in% factor_names) &
                (!is.na(data$referring_url))] <- NA

data$referring_url <- factor(data$referring_url)

## LONG URLs

factor_levels <- length(levels(data$long_url))

url_amounts <- sort(table(data$long_url), decreasing = TRUE)

accumulated <- numeric(factor_levels)
total <- sum(!is.na(data$long_url))
for(i in 1:factor_levels){
  accumulated[i] <- sum(url_amounts[1:i]/total)
}

require(ggplot2)

ggplot()+geom_line(aes(x=1:factor_levels,y=accumulated),colour="RED")

max_level <- which(accumulated >= 0.8)[1]

factor_names <- as.factor(row.names(url_amounts[1:max_level]))

data$long_url[(!data$long_url %in% factor_names) &
                     (!is.na(data$long_url))] <- NA

data$long_url <- factor(data$long_url)

## COUNTRY CODE

data$country_code <- as.factor(data$country_code)

factor_levels <- length(levels(data$country_code))

url_amounts <- sort(table(data$country_code), decreasing = TRUE)

accumulated <- numeric(factor_levels)
total <- sum(!is.na(data$country_code))
for(i in 1:factor_levels){
  accumulated[i] <- sum(url_amounts[1:i]/total)
}

require(ggplot2)

ggplot()+geom_line(aes(x=1:factor_levels,y=accumulated),colour="RED")

max_level <- which(accumulated >= 0.9)[1]

factor_names <- as.factor(row.names(url_amounts[1:max_level]))

data$country_code[(!data$country_code %in% factor_names) &
                (!is.na(data$country_code))] <- NA

data$country_code <- factor(data$country_code)

## USER AGENT

# User Agent profiles (Browser + OS + Device)
tuples <- paste(data$ua, data$os, data$dev, sep=', ')
tuples[is.na(data$ua) | is.na(data$os) | is.na(data$dev)] <- NA
tuples <- as.factor(tuples)

factor_levels <- length(levels(tuples))

amounts <- sort(table(tuples), decreasing = TRUE)

accumulated <- numeric(factor_levels)
total <- sum(!is.na(tuples))
for(i in 1:factor_levels){
  accumulated[i] <- sum(amounts[1:i]/total)
}

require(ggplot2)

ggplot()+geom_line(aes(x=1:factor_levels,y=accumulated),colour="RED")

max_level <- which(accumulated >= 0.85)[1]

factor_names <- as.factor(row.names(amounts[1:max_level]))

tuples[(!tuples %in% factor_names) & (!is.na(tuples))] <- NA

tuples <- factor(tuples)

data$ua_profiles <- tuples
