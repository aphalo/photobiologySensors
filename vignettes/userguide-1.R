## ----echo=FALSE---------------------------------------------------------------
knitr::opts_chunk$set(fig.width=8, fig.height=4)

## ----message=FALSE------------------------------------------------------------
library(photobiology)
library(photobiologySensors)
library(photobiologyWavebands)
eval_ggspectra <- TRUE
library(ggspectra)

## -----------------------------------------------------------------------------
camera.spct <- image_sensors.mspct[[1]]
str(attr(camera.spct, "sensor.properties"))

## -----------------------------------------------------------------------------
what_measured(camera.spct)
how_measured(camera.spct)
cat(comment(camera.spct))

## -----------------------------------------------------------------------------
names(sensors.mspct)

## -----------------------------------------------------------------------------
names(image_sensors.mspct)

## -----------------------------------------------------------------------------
sensors.mspct$LICOR_LI_190R

## -----------------------------------------------------------------------------
sensors.mspct[["LICOR_LI_190R"]]

## -----------------------------------------------------------------------------
sensors.mspct["LICOR_LI_190R"]

## -----------------------------------------------------------------------------
sensors.mspct[berger_sensors]

## -----------------------------------------------------------------------------
sensors.mspct[grep("berger", names(sensors.mspct), ignore.case = TRUE)]

## -----------------------------------------------------------------------------
sensors.mspct[intersect(licor_sensors, par_sensors)]

## -----------------------------------------------------------------------------
my.spct <- fscale(sensors.mspct$LICOR_LI_190R,
                  range = PhR(),
                  q_response,
                  target = 100,
                  set.scaled = FALSE)
q_response(my.spct, PhR())
q_response(my.spct, UVA())

## -----------------------------------------------------------------------------
getScaled(my.spct)

## -----------------------------------------------------------------------------
my2nd.spct <- sensors.mspct$LICOR_LI_190
setNormalized(my2nd.spct)
q_response(my2nd.spct)

## ----eval=eval_ggspectra------------------------------------------------------
autoplot(sensors.mspct$LICOR_LI_190R, 
         annotations = c("+", "title:what:how:comment"))

## ----eval=eval_ggspectra------------------------------------------------------
ggplot(sensors.mspct$LICOR_LI_190R, unit.out = "photon") +
  geom_hline(yintercept = 1, colour = "red") +
  geom_hline(yintercept = c(0.9, 1.1), colour = "red", linetype = "dotted") +
  geom_line(linetype = "dashed") +
  scale_y_s.q.response_continuous(breaks = c(0, 0.5, 1)) +
  scale_x_wl_continuous() +
  theme_classic()

## ----eval=eval_ggspectra------------------------------------------------------
ggplot(diffusers.lst$bentham_D7, aes(angle.deg, response)) +
  geom_line() +
  geom_line(aes(y = cos(angle.deg * pi / 180)), linetype = "dotted", color = "red") +
  scale_x_continuous(name = "Angle (degrees)", breaks = c(-90, -60, -30, 0, 30, 60, 90)) +
  scale_y_continuous(name = "Response (/1)") +
  theme_classic()

## -----------------------------------------------------------------------------
angular_response(45, "cosine")
angular_response(45, "dome")
angular_response(45, "sphere")

## -----------------------------------------------------------------------------
head(as.data.frame(sensors.mspct$LICOR_LI_190R))

## -----------------------------------------------------------------------------
attach(sensors.mspct)
head(LICOR_LI_190R)
detach(sensors.mspct)

## -----------------------------------------------------------------------------
attach(sensors.mspct)
with(LICOR_LI_190, max(w.length))
detach(sensors.mspct)

## -----------------------------------------------------------------------------
with(sensors.mspct, wl_range(LICOR_LI_190))

