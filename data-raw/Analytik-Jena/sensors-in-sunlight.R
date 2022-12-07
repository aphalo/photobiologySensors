library(photobiologySensors)
library(photobiologyLamps)
library(photobiologyFilters)

library(ggspectra)

photon_as_default()

autoplot(convolve_each(sensors.mspct[c("Analytik_Jena_UVX31", "Analytik_Jena_UVX36")], sun.spct),
         facets = 1) +
  ggtitle("Response to sunlight")

autoplot(convolve_each(sensors.mspct[c("Analytik_Jena_UVX31", "Analytik_Jena_UVX36")],
                       lamps.mspct$Philips.FT.TL.40W.12.uv),
         facets = 1) +
  ggtitle("Response to Philips TL 12 (UV-B broad)")

autoplot(convolve_each(sensors.mspct[c("Analytik_Jena_UVX31", "Analytik_Jena_UVX36")],
                       (lamps.mspct$Philips.FT.TL.40W.12.uv * filters.mspct$Courtaulds_CA_115um)),
         facets = 1) +
  ggtitle("Response to Philips TL 12 (UV-B broad) + acetate")

autoplot(convolve_each(sensors.mspct[c("Analytik_Jena_UVX31", "Analytik_Jena_UVX36")],
                       (lamps.mspct$Philips.FT.TL.40W.12.uv * polyester.spct)),
         facets = 1) +
  ggtitle("Response to Philips TL 12 (UV-B broad) + PET")

autoplot(convolve_each(sensors.mspct[c("Analytik_Jena_UVX31", "Analytik_Jena_UVX36")],
                       lamps.mspct$Philips.FT.TL.40W.01.uv),
         facets = 1) +
  ggtitle("Response to Philips TL 01 (UV-B narrow)")
