library(dplyr)
library(ggplot2)

read.csv2("data-raw/diffusers/sglux-cosine-enh.csv") %>%
  transmute(angle.deg = Line.2.x,
            angle.rad = angle.deg * pi / 180,
            response = Line.2.y / 100,
            cosine = cos(angle.rad),
            response.over.cosine = response / cosine) -> sglux_cosine_enh.df

ggplot(sglux_cosine_enh.df, aes(x = angle.deg)) +
  geom_line(aes(y = cosine), linetype = "dotted") +
  geom_line(aes(y = response))

ggplot(sglux_cosine_enh.df, aes(x = angle.deg, y = response.over.cosine)) +
  geom_hline(yintercept = 1, linetype = "dotted") +
  geom_line() +
  xlim(-85, 85)


read.csv2("data-raw/diffusers/sglux-cosine.csv") %>%
  transmute(angle.deg = Line.2.x,
            angle.rad = angle.deg * pi / 180,
            response = Line.2.y / 100,
            cosine = cos(angle.rad),
            response.over.cosine = response / cosine) -> sglux_cosine.df

ggplot(sglux_cosine.df, aes(x = angle.deg)) +
  geom_line(aes(y = cosine), linetype = "dotted") +
  geom_line(aes(y = response))

ggplot(sglux_cosine.df, aes(x = angle.deg, y = response.over.cosine)) +
  geom_hline(yintercept = 1, linetype = "dotted") +
  geom_line() +
  xlim(-85, 85)


read.csv2("data-raw/diffusers/TOCON-cosine.csv") %>% # head()
  transmute(angle.deg = Line.3.x,
            angle.rad = angle.deg * pi / 180,
            response = Line.3.y / 100,
            cosine = cos(angle.rad),
            response.over.cosine = response / cosine) -> TOCON_cosine.df

ggplot(TOCON_cosine.df, aes(x = angle.deg)) +
  geom_line(aes(y = cosine), linetype = "dotted") +
  geom_line(aes(y = response))

ggplot(TOCON_cosine.df, aes(x = angle.deg, y = response.over.cosine)) +
  geom_hline(yintercept = 1, linetype = "dotted") +
  geom_line() +
  xlim(-85, 85)
