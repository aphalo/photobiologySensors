library(dplyr)
library(ggplot2)

# read cosine response

read.csv2("data-raw/diffusers/sglux-cosine-enh.csv") %>%
  transmute(angle.deg = Line.2.x,
            angle.rad = angle.deg * pi / 180,
            response = Line.2.y / 100,
            cosine = cos(angle.rad),
            response.over.cosine = response / cosine) %>%
  filter(angle.deg > -85 & angle.deg < 85) %>%
  select(angle.deg, response, response.over.cosine) -> sglux_cosine_enh.df

read.csv2("data-raw/diffusers/sglux-cosine.csv") %>%
  transmute(angle.deg = Line.2.x,
            angle.rad = angle.deg * pi / 180,
            response = Line.2.y / 100,
            cosine = cos(angle.rad),
            response.over.cosine = response / cosine) %>%
  filter(angle.deg > -85 & angle.deg < 85) %>%
  select(angle.deg, response, response.over.cosine) -> sglux_cosine.df

read.csv2("data-raw/diffusers/TOCON-cosine.csv") %>%
  transmute(angle.deg = Line.3.x,
            angle.rad = angle.deg * pi / 180,
            response = Line.3.y / 100,
            cosine = cos(angle.rad),
            response.over.cosine = response / cosine) %>%
  filter(angle.deg > -85 & angle.deg < 85) %>%
  select(angle.deg, response, response.over.cosine) -> TOCON_cosine.df

read.csv2("data-raw/diffusers/OO4mm-Ylianttila2005.csv") %>%
  transmute(angle.deg = Dataset.x,
            angle.rad = angle.deg * pi / 180,
            response.over.cosine = Dataset.y,
            cosine = cos(angle.rad),
            response = response.over.cosine * cosine) %>%
  select(angle.deg, response, response.over.cosine) -> OO4mm_cosine.df

read.csv2("data-raw/diffusers/D7-web.csv") %>%
  transmute(angle.deg = Line.14.x,
            angle.rad = angle.deg * pi / 180,
            response.over.cosine = Line.14.y,
            cosine = cos(angle.rad),
            response = response.over.cosine * cosine) %>%
  select(angle.deg, response, response.over.cosine) -> Bentham_D7_cosine.df

read.csv2("data-raw/diffusers/J1002-manual-Fig3.csv") %>%
  transmute(angle.deg = Line.4.x,
            angle.rad = angle.deg * pi / 180,
            response.over.cosine = Line.4.y,
            cosine = cos(angle.rad),
            response = response.over.cosine * cosine) %>%
  select(angle.deg, response, response.over.cosine) -> Schreder_J1002_cosine.df

read.csv2("data-raw/diffusers/Scintec.csv") %>%
  transmute(angle.deg = Line.3.x,
            angle.rad = angle.deg * pi / 180,
            response.over.cosine = 1 + Line.3.y / 100,
            cosine = cos(angle.rad),
            response = response.over.cosine * cosine) %>%
  select(angle.deg, response, response.over.cosine) -> Scintec_cosine.df

read.csv2("data-raw/diffusers/Scintec.csv") %>%
  transmute(angle.deg = Line.3.x,
            angle.rad = angle.deg * pi / 180,
            response.over.cosine = 1 + Line.3.y / 100,
            cosine = cos(angle.rad),
            response = response.over.cosine * cosine) %>%
  select(angle.deg, response, response.over.cosine) -> Scintec_cosine.df

read.csv2("data-raw/diffusers/SL501_typ.csv") %>%
  transmute(angle.deg = Line.3.x,
            angle.rad = angle.deg * pi / 180,
            response.over.cosine = 1 + Line.3.y / 100,
            cosine = cos(angle.rad),
            response = response.over.cosine * cosine) %>%
  select(angle.deg, response, response.over.cosine) -> SL501_cosine.df

read.csv2("data-raw/diffusers/VitalBW20.csv") %>%
  transmute(angle.deg = Line.3.x,
            angle.rad = angle.deg * pi / 180,
            response.over.cosine = 1 + Line.3.y / 100,
            cosine = cos(angle.rad),
            response = response.over.cosine * cosine) %>%
  select(angle.deg, response, response.over.cosine) -> VitalBW20_cosine.df

diffusers.lst <- list(sglux.uvi.cosine = sglux_cosine_enh.df,
                      sglux.uv.cosine = sglux_cosine.df,
                      sglux.TOCON = TOCON_cosine.df,
                      ocean.optics.4mm = OO4mm_cosine.df,
                      bentham.D7 = Bentham_D7_cosine.df,
                      schreder.J1002 = Schreder_J1002_cosine.df,
                      Scintec = Scintec_cosine.df,
                      solarlight.501 = SL501_cosine.df,
                      vital.BW20 = VitalBW20_cosine.df)

save(diffusers.lst, file = "data/diffusers-lst.rda")

for (name in names(diffusers.lst)) {
  diffusers.lst[[name]][["diffuser"]] <- name
}

diffusers.df <- bind_rows(diffusers.lst)

ggplot(diffusers.df,
       aes(angle.deg, response.over.cosine, color = diffuser)) +
  geom_line()

ggplot(diffusers.df,
       aes(angle.deg, response, color = diffuser)) +
  geom_line()
