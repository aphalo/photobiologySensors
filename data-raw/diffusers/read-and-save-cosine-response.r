library(dplyr)
library(ggplot2)
library(photobiology)

## Digitized data can contain too dense data as well as slightly displaced
## values, we first smooth the data and then re-express at 2 degree steps
thin_angles <- function(df,
                        step = 2,
                        span = 0.25) {

  target.angles <- seq(from = -88, to = 88, by = step)

  df <- df[ , c("angle.deg", "response")]
  stopifnot(ncol(df) == 2L)

  df <- na.omit(df)
  stopifnot(nrow(df) > 20L)

  # s <- supsmu(x = df$angle.deg, y = df$response, bass = bass)
  # stopifnot(sum(is.na(df$y)) < 5L)
  # stopifnot(sum(is.na(df$x)) == 0L)
  # s <- na.omit(s)

  # z.loess <-
  #   loess(y ~ x, data = s, na.action = na.omit)

  z.loess <-
    loess(response ~ angle.deg, data = df, na.action = na.omit, span = span)

  # z <- data.frame(x = target.angles)
  z <- data.frame(angle.deg = target.angles)
  z.pred <- predict(z.loess, newdata = z, se = FALSE)
  # names(z)[1] <- "angle.deg"
  z$response <- z.pred
  if (min(z$response, na.rm = TRUE) < 0) {
    z$response <- z$response - min(z$response, na.rm = TRUE)
  }
  z$response <- z$response / max(z$response, na.rm = TRUE)
  z$response.over.cosine <- z$response / cos(z$angle.deg * pi / 180)
  comment(z) <- comment(df)
  z
}

# read angular responses

read.csv("data-raw/diffusers/LICOR-LI-190R-200R-210R-cosine.csv",
         header = FALSE, col.names = c("angle.deg", "response.over.cosine")) %>%
  mutate(angle.rad = angle.deg * pi / 180,
         cosine = cos(angle.rad),
         response = response.over.cosine * cosine,
         response = response / max(response)) %>%
  filter(angle.deg > -85 & angle.deg < 85) %>%
  select(angle.deg, response, response.over.cosine) -> LICOR_R_cosine_right.df
  LICOR_R_cosine_left.df <- LICOR_R_cosine_right.df
  LICOR_R_cosine_left.df$angle.deg <- -LICOR_R_cosine_right.df$angle.deg
  LICOR_R_cosine.df <- rbind(LICOR_R_cosine_left.df, LICOR_R_cosine_right.df)
  LICOR_R_cosine.df <- LICOR_R_cosine.df[order(LICOR_R_cosine.df$angle.deg), ]
comment(LICOR_R_cosine.df) <-
  paste("Angular response of sensors LI-190R, LI-200R and LI-210R from LI-COR Biosciences",
        "Digitized from Fig. in Technical Note 'Why Upgrade to the \"R\" Light and Radiation Sensors?' dated 2015, PDF version downloaded from LI-COR's website on 2022-12-6",
        sep = "\n")

read.csv("data-raw/diffusers/Analytik-angular-response.csv",
         header = FALSE, col.names = c("angle.deg", "response")) %>%
  mutate(angle.rad = angle.deg * pi / 180,
         response = response / max(response),
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
            response = response / max(response),
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
            response = response / max(response),
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
            response = response / max(response),
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
            response = response.over.cosine * cosine,
            response = response / max(response)) %>%
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
            response = response.over.cosine * cosine,
            response = response / max(response)) %>%
  subset(angle.deg > -90 & angle.deg < 90) %>%
  select(angle.deg, response, response.over.cosine) -> Bentham_D7_cosine.df
comment(Bentham_D7_cosine.df) <-
  paste("Angular response of diffuser D7 from Bentham Instruments, Reading, UK",
        "Digitized from figure in website, last visited 2022-12-07",
        sep = "\n")

read.csv("data-raw/diffusers/D7-custom-dome-calibration.csv",
          header = FALSE, col.names = c("angle.deg", "response"))  %>%
  mutate(angle.rad = angle.deg * pi / 180,
         cosine = cos(angle.rad),
         response = response / max(response),
         response.over.cosine = response / cosine) %>%
  subset(angle.deg > -85 & angle.deg < 85) %>%
  select(angle.deg, response, response.over.cosine)-> Bentham_D7_dome.df
comment(Bentham_D7_dome.df) <-
  paste("Angular response of diffuser D7 'customized dome' prototype from Bentham Instruments, Reading, UK",
        "Digitized from figure in calibration certificate for s/n 35702, a prototype made to order for P. J. Aphalo, dated 2021-11-12",
        sep = "\n")

read.csv2("data-raw/diffusers/J1002-manual-Fig3.csv") %>%
  transmute(angle.deg = Line.4.x,
            angle.rad = angle.deg * pi / 180,
            response.over.cosine = Line.4.y,
            cosine = cos(angle.rad),
            response = response.over.cosine * cosine,
            response = response / max(response)) %>%
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
            response = response.over.cosine * cosine,
            response = response / max(response)) %>%
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
            response = response.over.cosine * cosine,
            response = response / max(response)) %>%
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
            response = response.over.cosine * cosine,
            response = response / max(response)) %>%
  select(angle.deg, response, response.over.cosine) -> VitalBW20_cosine.df
comment(VitalBW20_cosine.df) <-
  paste("Angular response of sensors as measured in international intercomparison",
        "From Ylianttila et al. (2005)",
        sep = "\n")

diffusers.lst <- list(analytik.jena.cosine = analytik_jena_cosine.df,
                            bentham.D7 = Bentham_D7_cosine.df,
                            bentham.D7.dome = Bentham_D7_dome.df,
                            licor.R = LICOR_R_cosine.df,
                            ocean.optics.4mm = OO4mm_cosine.df,
                            sglux.uvi.cosine = sglux_cosine_enh.df,
                            sglux.uv.cosine = sglux_cosine.df,
                            sglux.TOCON = TOCON_cosine.df,
                            schreder.J1002 = Schreder_J1002_cosine.df,
                            Scintec = Scintec_cosine.df,
                            Solarlight.501 = SL501_cosine.df,
                            vital.BW20 = VitalBW20_cosine.df)

all_diffusers <- names(diffusers.lst)
dome_diffusers <- grep("dome", all_diffusers, value = TRUE)
cosine_diffusers <- setdiff(all_diffusers, dome_diffusers)

for (d in all_diffusers) {
  print(d)
  diffusers.lst[[d]] <- thin_angles(diffusers.lst[[d]], step = 1, span = 0.2)
}
save(all_diffusers, dome_diffusers, cosine_diffusers,
     diffusers.lst, file = "data/diffusers-lst.rda")

for (name in names(diffusers.lst)) {
  diffusers.lst[[name]][["diffuser"]] <- name
}

diffusers.df <- bind_rows(diffusers.lst)

ggplot(diffusers.df,
       aes(angle.deg, response.over.cosine, color = diffuser)) +
  geom_hline(yintercept = 1) +
  geom_line() +
  expand_limits(y = 0) +
  theme_bw()

ggplot(subset(diffusers.df, diffuser %in%
                c("analytik.jena.cosine", "bentham.D7", "sglux.uvi.cosine")),
aes(angle.deg, response.over.cosine, color = diffuser)) +
  geom_hline(yintercept = 1) +
  geom_line() +
  expand_limits(y = 0) +
  theme_bw()

ggplot(subset(diffusers.df, diffuser %in% dome_diffusers),
       aes(angle.deg, response, color = diffuser)) +
  geom_hline(yintercept = 1) +
  geom_line() +
  expand_limits(y = 0) +
  theme_bw()

ggplot(subset(diffusers.df, grepl("D7", diffuser)),
       aes(angle.deg, response, color = diffuser)) +
  geom_hline(yintercept = 1) +
  geom_line() +
  expand_limits(y = 0) +
  theme_bw()

ggplot(subset(diffusers.df, grepl("D7", diffuser)),
       aes(angle.deg, response.over.cosine, color = diffuser)) +
  geom_hline(yintercept = 1) +
  geom_line() +
  expand_limits(y = 0) +
  theme_bw()

ggplot(diffusers.df,
       aes(angle.deg, response, color = diffuser)) +
  geom_line() +
  geom_hline(yintercept = 1) +
  expand_limits(y = 0) +
  theme_bw()

