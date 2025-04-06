
# setup -------------------------------------------------------------------

setwd("./2025-04-01")

pacman::p_load(tidyverse, ggimage, pokemon, fs, png, Rtsne, fastDummies)


# data --------------------------------------------------------------------

## only gen 1
pokemon <- pokemon::pokemon %>%
  filter(generation_id == 1)

## get .pngs
sprites_urls <- paste0("https:", pokemon$url_icon)

sprites_path <- path("sprites", pokemon$pokemon, ext = "png")
missing_sprites_urls <- sprites_urls[!(file_exists(sprites_path))]
missing_sprites_path <- sprites_path[!(file_exists(sprites_path))]
if (length(missing_sprites) > 0) {walk2(missing_sprites_urls, missing_sprites_path, download.file, mode = "wb")}

sprites_tbl <- data.frame(pokemon = pokemon$pokemon,
                          sprite = sprites_path)

## vars
poke_vars <- pokemon %>%
  select(pokemon,
         height,
         weight,
         base_experience,
         type_1,
         hp,
         attack,
         defense,
         special_attack,
         special_defense,
         speed,
         egg_group_1) %>%
  dummy_cols(remove_selected_columns = TRUE,
             select_columns = c("type_1", "egg_group_1"))

## tsne
poke_vars_scaled <- scale(poke_vars %>% select(-pokemon))

set.seed(239847)
poke_tsne <- Rtsne(poke_vars, dims = 2, perplexity = 10)
poke_tsne_df <- data.frame(pokemon = poke_vars$pokemon,
                           poke_tsne$Y)

## merge w/ pngs
sprites_tbl_plot <- sprites_tbl %>%
  merge(poke_tsne_df,
        by = "pokemon",
        all.x = TRUE)

# plots -------------------------------------------------------------------

out_plot <- sprites_tbl_plot %>%
  ggplot(aes(x = X1, y = X2)) + 
  geom_image(aes(image = sprite), size = .1) +
  theme_bw() +
  labs(title = "Pokemon tSNE Plot",
       subtitle = "Tidy Tuesday 2025-04-01",
       x = NULL,
       y = NULL) 
# +
#   theme(axis.text.x = element_blank(),
#         axis.text.y = element_blank(),
#         axis.ticks = element_blank())

print(out_plot)
ggsave("out_plot.png", plot = out_plot, width = 6, height = 4, dpi = 300)
