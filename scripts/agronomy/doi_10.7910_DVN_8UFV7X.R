# R script for "carob"
# license: GPL (>=3)

## ISSUES
# - Auto-rejected by carobiner::draft() (no columns matched terminag heuristics);
#   script written manually after data exploration
# - Simple factorial split-plot experiment: sesame intercropped with maize, northern Ghana 2014
# - Treatment 1: planting time (1=mid July, 2=late July, 3=mid August)
# - Treatment 2: spraying regime (1=once, 2=twice, 3=thrice) - all plots sprayed
# - GRAIN yield values (31-53) are low for sesame kg/ha (yield units unknown);
#   units not specified in readme - may be g/plot or need conversion factor
# - Only sesame response data; no maize yield in this dataset
# - adm1/location from dataset description (Northern Ghana); not in data file
# - 27 observations (3 reps x 3 planting times x 3 spraying regimes)
# - exact planting dates approximated from planting time codes in readme
# - suggested terms: pod_count (number of capsules per plant); branches (number of branches per plant)

carob_script <- function(path) {
  
  "
Maize-Sesame Intercropping Trial, Northern Ghana 2014

Split-plot experiment evaluating planting time (mid July, late July, mid August)
and herbicide spraying frequency (1-3 times) effects on sesame yield and growth
in a maize-sesame intercropping system. Part of the AfricaRISING project on
sustainable intensification of cereal-based farming systems in the
Guinea-Sudan Savanna of Ghana and Mali.
"
  
  uri <- "doi:10.7910/DVN/8UFV7X"
  group <- "agronomy"
  ff <- carobiner::get_data(uri, path, group)
  
  meta <- carobiner::get_metadata(uri, path, group, major=2, minor=0,
                                  data_organization = "IITA; SARI",
                                  publication = NA,
                                  project = "AfricaRISING",
                                  design = "split-plot",
                                  data_type = "experiment",
                                  treatment_vars = "planting_date;herbicide_times",
                                  response_vars = "yield;plant_height",
                                  notes = "NA",
                                  carob_contributor = "Stella Muthoni",
                                  carob_date = "2026-07-07",
                                  carob_completion = 80,
                                  carob_effort = 1
  )
  
  r1 <- read.csv(ff[basename(ff) == "001_maizeSesameIntercropping.csv"])
  
  d <- data.frame(
    trial_id           = as.character(r1$REP),
    country            = "Ghana",
    adm1               = "Northern",
    geo_from_source    = FALSE,
    latitude           = NA,
    longitude          = NA,
    is_survey          = FALSE,
    on_farm            = TRUE,
    irrigated          = FALSE,
    crop               = "sesame",
    intercrops         = "maize",
    rep                = r1$REP,
    planting_date      = ifelse(r1$PLNTING == 1, "2014-07",
                                ifelse(r1$PLNTING == 2, "2014-07", "2014-08")),
    herbicide_used     = TRUE,
    herbicide_times    = r1$SPRYR,
    N_fertilizer       = NA,
    P_fertilizer       = NA,
    K_fertilizer       = NA,
    yield              = r1$GRAIN,
    yield_part         = "seed",
    yield_moisture     = NA,
    yield_isfresh      = FALSE,
    plant_height       = r1$PLNTH,
    pod_count = r1$NCAPS,    # number of capsules per plant
    branches = r1$NBRNCH     # number of branches per plant
  )
  
  carobiner::write_files(path, meta, d)
}