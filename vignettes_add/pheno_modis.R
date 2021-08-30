
settings_modis <- get_settings_modis(
  bundle            = "modis_pheno",
  data_path         = "~/pep/data/",
  keep              = TRUE,
  overwrite_raw     = TRUE,
  overwrite_interpol= TRUE
)

# 1 site

dff_modis_pheno <- ingest_bysite(
  sitename  = "testsite10",
  source    = "modis",
  year_start= 2001,
  year_end  = 2018,
  lon       = -77.1,
  lat       = 42.3,
  settings  = settings_modis,
  verbose   = FALSE
)
dff_modis_pheno %>% tidyr::drop_na(pixel)

# More than 1 site

sampled_pixels <- readRDS("~/pep/data/sampled_pixels.rds")
# Select the sample pixels as data.frame to run the fc. mt_batch_subset
sampled_pixels$sitename <- paste0("testf",rownames(sampled_pixels)) 
sampled_pixels <- sampled_pixels %>% relocate(sitename) 
sampled_pixels <- sampled_pixels %>% mutate(date_start = "2001-01-01", date_end = "2018-01-01")
#sampled_pixels <- as_tibble(sampled_pixels)

data_modis_phenol <- data.frame() 

for(i in 1:nrow(sampled_pixels)) { # nrow(sampled_pixels)
  
  df_modis_pheno_sub <- ingest_bysite(
    sitename  = sampled_pixels$sitename[i],
    source    = "modis",
    year_start= 2001,
    year_end  = 2018,
    lon       = sampled_pixels$lon[i],
    lat       = sampled_pixels$lat[i],
    settings  = settings_modis,
    verbose   = FALSE
  )
  df_modis_pheno_sub <- df_modis_pheno_sub %>% tidyr::drop_na()
  
  data_modis_phenol <- rbind(data_modis_phenol, df_modis_pheno_sub)
}

saveRDS(data_modis_phenol, "~/pep/data/data_modis_phenol.rds")
length(unique(data_modis_phenol$sitename))


