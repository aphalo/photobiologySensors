
sglux_response.tb <- read.csv2("sglux-angular-response.csv")
names(sglux_response.tb) <- c("angle_degrees", "response")
sglux_response.tb$cosine <- cos(sglux_response.tb$angle_degrees * pi / 180)
sglux_response.tb$relative <- with(sglux_response.tb, response / cosine)

plot(relative ~ angle_degrees, data = sglux_response.tb,
     subset = angle_degrees >= -85 & angle_degrees <= 85)
