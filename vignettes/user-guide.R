## ---- echo=FALSE--------------------------------------------------------------
knitr::opts_chunk$set(fig.width=8, fig.height=4)

## ---- message=FALSE-----------------------------------------------------------
library(photobiology)
library(photobiologyWavebands)
library(photobiologySensors)
library(ggplot2)
library(ggspectra)

## -----------------------------------------------------------------------------
names(sensors.mspct)

## -----------------------------------------------------------------------------
sensors.mspct$LICOR_LI_190

## -----------------------------------------------------------------------------
sensors.mspct[["LICOR_LI_190"]]

## -----------------------------------------------------------------------------
sensors.mspct["LICOR_LI_190"]

## -----------------------------------------------------------------------------
sensors.mspct[berger_sensors]

## -----------------------------------------------------------------------------
sensors.mspct[grep("berger", names(sensors.mspct), ignore.case = TRUE)]

## -----------------------------------------------------------------------------
sensors.mspct[intersect(licor_sensors, par_sensors)]

## -----------------------------------------------------------------------------
my.spct <- fscale(sensors.mspct$LICOR_LI_190,
                  range = PAR(),
                  q_response,
                  target = 1
                  )
q_response(my.spct, PAR())
q_response(my.spct, UVA())

## -----------------------------------------------------------------------------
getScaled(my.spct)

## -----------------------------------------------------------------------------
my2nd.spct <- sensors.mspct$LICOR_LI_190
setNormalized(my2nd.spct)
q_response(my2nd.spct)

## -----------------------------------------------------------------------------
autoplot(sensors.mspct$LICOR_LI_190)

## -----------------------------------------------------------------------------
ggplot(sensors.mspct$LICOR_LI_190, unit.out = "photon") +
  geom_hline(yintercept = 1, colour = "red") +
  geom_hline(yintercept = c(0.9, 1.1), colour = "red", linetype = "dotted") +
  geom_line(linetype = "dashed") +
  scale_y_s.q.response_continuous(breaks = c(0, 0.5, 1)) +
  scale_x_wl_continuous() +
  theme_classic()

## -----------------------------------------------------------------------------
head(as.data.frame(sensors.mspct$LICOR_LI_190))

## -----------------------------------------------------------------------------
attach(sensors.mspct)
q_response(LICOR_LI_190, Red())
detach(sensors.mspct)

## -----------------------------------------------------------------------------
attach(sensors.mspct)
with(LICOR_LI_190, max(w.length))
detach(sensors.mspct)

## -----------------------------------------------------------------------------
with(sensors.mspct, q_response(LICOR_LI_190, Red()))

