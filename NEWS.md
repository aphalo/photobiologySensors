---
editor_options:
  markdown:
    wrap: 72
---

photobiologySensors 0.5.2
=========================

* Data objects rebuilt with 'photobiology' 0.14.0.
* Add data for the 13-channel AS7343 digital spectral sensor from ams-OSRAM.
* Add data for the 11-channel AS7341 digital spectral sensor from ams-OSRAM.
* Add data for the 3-channel AS7331 digital ultraviolet sensor from ams-OSRAM.
* Add data for the 2-channel TSL2591 digital ambient light sensor from ams-OSRAM.
* Add data for Kipp CM21 thermopile pyranometer.

photobiologySensors 0.5.1
=========================

** Data have changed, with vectors in many cases being shorter and wavelength
steps of irregular size, but with minimal change in the information.**

* Rebuild all spectral data objects with 'photobiology' (== 0.11.0) adding
metadta, using smoothing of digitized curves and thinning of wavelengths.
* Rebuild all angular response data data frames using loess to re-express 
data at 1 degree intervals when possible, and slightly smooth the digitized data.
* Add data for Analytik-Jena UV sensors UVX-25, UVX-31 and UVX-36.
* Add data for Apogee sensors for PAR, ePAR, red+far-red, and UVA.
* Add data for Specmeters sensor for PAR.
* Add data for ams-OSRAM TSL-series Si light-to-voltage IC sensors.
* Add data for the newer R-type of LI-COR sensors.
* Add data for a prototype "custom-made dome-shaped" D7 diffuser variant from
Bentham.
* Move Git repository from Bitbucket to GitHub.
* Set up continuous integration (CI) for checks in GitHub repository.

photobiologySensors 0.5.0
=========================

* Rename member spectra by prepending suppliers' names and rebuild sensors.mspct
with photobiology (0.10.5) which is now required.
* Add data for angular responsivity saved in a list of data frames
named diffusers.lst.

---

Code breaking because of renaming of members of the collection of spectra

---

photobiologySensors 0.4.0
=========================

Reorganise data storage into a single collection of spectra. Add character
vectors of names for use in subsetting the collection.
This is a code-breaking update, that will require revision to match the new
data structure and naming scheme.
First CRAN version.

photobiologySensors 0.3.3
=========================

Update for ggplot2 2.0.0, ggspectra 0.1.0, and photobiology 0.9.1.
Removed the User Guide as it was not specificc to the data in this pacakge.

photobiologySensors 0.3.2
=========================

Rebuild all data and the package with photobiology 0.8.0.
Inprove the "thinning" algorithm used with the digitized
spectral data.

photobiologySensors 0.3.1
=========================

Added data for Delta-T BF5 sunshine sensor.
Digitized again data for lux sensor Skye SKL 310.

All data rebuilt with photobiology 0.6.8, and now
all spectral data is normalized to one at the wavelength
of maximum energy responisvity.

Fixed the "thinning" algorithm of the spectral response data
because it was deleting the observations at the longest wavelength
values.

photobiologySensors 0.3.0
=========================

All data rebuilt with photobiology 0.6.0.
"Thinned" some of the spectral response data because it had been
digitized with a very small wavelength step size.

Small tweaks to the vignettes.

photobiologySensors 0.2.2
=========================

Rebuilt with new version of package photobiology.

photobiologySensors 0.2.1
=========================

Added data for sensors made by Skye Instruments. Data digitised from brochures and manuals.
Added plots of the newly added spectra to the vignette.

photobiologySensors 0.2.0
=========================

Added the spectral data generously supplied as a file by sglux for their sensors.
Rebuilt all data objects and data .r files with photobiology 0.5.7 which is now required.
Editted the vignettes to use the high level functions currently available in the suite.
As a result the code for the example calculations is now much simpler, and
consequently, hopefully, also much easier to understand for the user.

photobiologySensors 0.1.8
=========================

Rebuilt data object and data .r files and fixed one example in docs.
Fixed bugs that rendered data for some sensors inaccessible.

photobiologySensors 0.1.7
=========================

Added data for Thies sensor and modified automatic data objects build to use response.spct objects.

photobiologySensors 0.1.6
=========================

Fixed a bug that surfaced after trim_tails was modified to allow extrapolation. Cleaned the vignettes.

photobiologySensors 0.1.5
=========================

Added more spectra for sglux TOCON sensors.
Vignette of spectra updated to include the new data and plotting adjusted a little.

photobiologySensors 0.1.4
=========================

Vignette of spectra now shows peaks.

photobiologySensors 0.1.3
=========================

Added data for Solar Light and Vital Technologies sensors from WMO-STUK intercomparison. Data kindly made available by Lasse Ylianttila (STUK). First version of User Guide.

photobiologySensors 0.1.2
=========================

Calc_sensor_multipliers bug fixed. Sensor data files cleaned. Vignette now builds correctly.

photobiologySensors 0.1.1
=========================

Added Solarmeter MODEL 6.0 UV meter.

photobiologySensors 0.1.0
=========================

First version. Includes response spectra for sensors for which we have found data online.
