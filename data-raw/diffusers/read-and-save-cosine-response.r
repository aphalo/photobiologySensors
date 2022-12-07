library(dplyr)
library(ggplot2)
library(photobiology)

# read cosine response

read.csv("data-raw/diffusers/Analytik-angular-response.csv",
         header = FALSE, col.names = c("angle.deg", "response")) %>%
  mutate(angle.rad = angle.deg * pi / 180,
            cosine = cos(angle.rad),
            response.over.cosine = response / cosine) %>%
  filter(angle.deg > -85 & angle.deg < 85) %>%
  select(angle.deg, response, response.over.cosine) -> analytik_jena_cosine.df
comment(analytik_jena_cosine.df) <-
  paste("Angular response of sensors UVX-25, UVX-31 and UVX-36 from Analytik Jena US (former UVP)",
        "Digitized from Fig. 9 in manual, PDF version downloaded from website on 2022-12-6",
        sep = "\n")

read.csv2("data-raw/diffusers/sglux-cosine-enh.csv") %>%
  transmute(angle.deg = Line.2.x,
            angle.rad = angle.deg * pi / 180,
            response = Line.2.y / 100,
            cosine = cos(angle.rad),
            response.over.cosine = response / cosine) %>%
  filter(angle.deg > -85 & angle.deg < 85) %>%
  select(angle.deg, response, response.over.cosine) -> sglux_cosine_enh.df
comment(sglux_cosine_enh.df) <-
  paste("Angular response of sensors in the UVAi series and others customized with the enhanced diffuser design from sglux, Berlin",
        "Digitized from data sheet, PDF version downloaded from website in 2020",
        sep = "\n")

read.csv2("data-raw/diffusers/sglux-cosine.csv") %>%
  transmute(angle.deg = Line.2.x,
            angle.rad = angle.deg * pi / 180,
            response = Line.2.y / 100,
            cosine = cos(angle.rad),
            response.over.cosine = response / cosine) %>%
  filter(angle.deg > -85 & angle.deg < 85) %>%
  select(angle.deg, response, response.over.cosine) -> sglux_cosine.df
comment(sglux_cosine.df) <-
  paste("Angular response of sensors in the UVC, UVB, UVA and Blue series with the regular diffuser design from sglux, Berlin",
        "Digitized from data sheet, PDF version downloaded from website in 2020",
        sep = "\n")

read.csv2("data-raw/diffusers/TOCON-cosine.csv") %>%
  transmute(angle.deg = Line.3.x,
            angle.rad = angle.deg * pi / 180,
            response = Line.3.y / 100,
            cosine = cos(angle.rad),
            response.over.cosine = response / cosine) %>%
  filter(angle.deg > -85 & angle.deg < 85) %>%
  select(angle.deg, response, response.over.cosine) -> TOCON_cosine.df
comment(sglux_cosine.df) <-
  paste("Angular response of miniature sensors in the TOCON series from sglux, Berlin",
        "Digitized from data sheet, PDF version downloaded from website in 2020",
        sep = "\n")

read.csv2("data-raw/diffusers/OO4mm-Ylianttila2005.csv") %>%
  transmute(angle.deg = Dataset.x,
            angle.rad = angle.deg * pi / 180,
            response.over.cosine = Dataset.y,
            cosine = cos(angle.rad),
            response = response.over.cosine * cosine) %>%
  select(angle.deg, response, response.over.cosine) -> OO4mm_cosine.df
comment(OO4mm_cosine.df) <-
  paste("Angular response of sensors as measured in international intercomparison",
        "From Ylianttila et al. (2005)",
        sep = "\n")

read.csv2("data-raw/diffusers/D7-web.csv") %>%
  transmute(angle.deg = Line.14.x,
            angle.rad = angle.deg * pi / 180,
            response.over.cosine = Line.14.y,
            cosine = cos(angle.rad),
            response = response.over.cosine * cosine) %>%
  select(angle.deg, response, response.over.cosine) -> Bentham_D7_cosine.df
comment(Bentham_D7_cosine.df) <-
  paste("Angular response of diffuser D7 from Bentham Instruments, Reading, UK",
        "Digitized from figure in website, last visited 2022-12-07",
        sep = "\n")

read.csv2("data-raw/diffusers/J1002-manual-Fig3.csv") %>%
  transmute(angle.deg = Line.4.x,
            angle.rad = angle.deg * pi / 180,
            response.over.cosine = Line.4.y,
            cosine = cos(angle.rad),
            response = response.over.cosine * cosine) %>%
  select(angle.deg, response, response.over.cosine) -> Schreder_J1002_cosine.df
comment(Schreder_J1002_cosine.df) <-
  paste("Angular response of sensors as measured in international intercomparison",
        "From Ylianttila et al. (2005)",
        sep = "\n")

read.csv2("data-raw/diffusers/Scintec.csv") %>%
  transmute(angle.deg = Line.3.x,
            angle.rad = angle.deg * pi / 180,
            response.over.cosine = 1 + Line.3.y / 100,
            cosine = cos(angle.rad),
            response = response.over.cosine * cosine) %>%
  select(angle.deg, response, response.over.cosine) -> Scintec_cosine.df
comment(Scintec_cosine.df) <-
  paste("Angular response of sensors as measured in international intercomparison",
        "From Ylianttila et al. (2005)",
        sep = "\n")

read.csv2("data-raw/diffusers/SL501_typ.csv") %>%
  transmute(angle.deg = Line.3.x,
            angle.rad = angle.deg * pi / 180,
            response.over.cosine = 1 + Line.3.y / 100,
            cosine = cos(angle.rad),
            response = response.over.cosine * cosine) %>%
  select(angle.deg, response, response.over.cosine) -> SL501_cosine.df
comment(SL501_cosine.df) <-
  paste("Angular response of sensors as measured in international intercomparison",
        "From Ylianttila et al. (2005)",
        sep = "\n")

read.csv2("data-raw/diffusers/VitalBW20.csv") %>%
  transmute(angle.deg = Line.3.x,
            angle.rad = angle.deg * pi / 180,
            response.over.cosine = 1 + Line.3.y / 100,
            cosine = cos(angle.rad),
            response = response.over.cosine * cosine) %>%
  select(angle.deg, response, response.over.cosine) -> VitalBW20_cosine.df
comment(VitalBW20_cosine.df) <-
  paste("Angular response of sensors as measured in international intercomparison",
        "From Ylianttila et al. (2005)",
        sep = "\n")

diffusers.lst <- list(analytik.jena.cosine = analytik_jena_cosine.df,
                      bentham.D7 = Bentham_D7_cosine.df,
                      ocean.optics.4mm = OO4mm_cosine.df,
                      sglux.uvi.cosine = sglux_cosine_enh.df,
                      sglux.uv.cosine = sglux_cosine.df,
                      sglux.TOCON = TOCON_cosine.df,
                      schreder.J1002 = Schreder_J1002_cosine.df,
                      Scintec = Scintec_cosine.df,
                      Solarlight.501 = SL501_cosine.df,
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
