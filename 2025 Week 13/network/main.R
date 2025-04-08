
# setup -------------------------------------------------------------------
setwd("C:/Users/dpoli/repos/tidy_tues/2025-04-01/network")

pacman::p_load(tidyverse, pokemon, fs, magick)

# images --------------------------------------------------------------------

pokemon_data <- pokemon::pokemon
         
sprites_path <- path("sprites", pokemon_data$pokemon, ext = "png")

sprites_tbl <- data.frame(pokemon = pokemon_data$pokemon,
                          sprite = sprites_path)

# OG pngs -----------------------------------------------------------------

# sprites_urls <- paste0("https:", pokemon_data$url_icon)
# missing_sprites_urls <- sprites_urls[!(file_exists(sprites_path))]
# missing_sprites_path <- sprites_path[!(file_exists(sprites_path))]
# if (length(missing_sprites_urls) > 0) {walk2(missing_sprites_urls, missing_sprites_path, download.file, mode = "wb")}


# remaining pngs ----------------------------------------------------------

# missing_sprites_urls <- pokemon_data$url_image[!(file_exists(sprites_path))]
# missing_sprites_path <- sprites_path[!(file_exists(sprites_path))]
# missing_poke <- pokemon_data$pokemon[!(file_exists(sprites_path))]
# 
# missing_poke_list <- c()
# 
# if (length(missing_sprites_urls) > 0) {
#   for (poke_ind in 1:length(missing_sprites_urls)) {
#     
#     tryCatch({
#       download.file(missing_sprites_urls[poke_ind], missing_sprites_path[poke_ind], mode = "wb")
#       init_img <- image_read(missing_sprites_path[poke_ind])
#       img_resized <- image_resize(init_img, "40x40!")
#       image_write(img_resized, missing_sprites_path[poke_ind])
#     }, error = function(e) {
#       missing_poke_list <<- append(missing_poke_list, missing_poke[poke_ind])
#       print(missing_sprites_path[poke_ind])
#       })
#     
#   }
# }
# 
# print(missing_poke_list)

pokemon_data <- pokemon_data %>%
  filter(!(pokemon %in% c("deoxys-attack", "deoxys-defense", "deoxys-speed", "wormadam-sandy", "wormadam-trash", "shaymin-sky", "giratina-origin", "rotom-heat", "rotom-wash", "rotom-frost", "rotom-fan", "rotom-mow", "castform-sunny", "castform-rainy", "castform-snowy", "basculin-blue-striped", "darmanitan-zen", "meloetta-pirouette", "tornadus-therian", "thundurus-therian", "landorus-therian", "kyurem-black", "kyurem-white", "keldeo-resolute", "meowstic-female", "aegislash-blade", "pumpkaboo-small", "pumpkaboo-large", "pumpkaboo-super", "gourgeist-small", "gourgeist-large", "gourgeist-super", "venusaur-mega", "charizard-mega-x", "charizard-mega-y", "blastoise-mega", "alakazam-mega", "gengar-mega", "kangaskhan-mega", "pinsir-mega", "gyarados-mega", "aerodactyl-mega", "mewtwo-mega-x", "mewtwo-mega-y", "ampharos-mega", "scizor-mega", "heracross-mega", "houndoom-mega", "tyranitar-mega", "blaziken-mega", "gardevoir-mega", "mawile-mega", "aggron-mega", "medicham-mega", "manectric-mega", "banette-mega", "absol-mega", "garchomp-mega", "lucario-mega", "abomasnow-mega", "floette-eternal", "latias-mega", "latios-mega", "swampert-mega", "sceptile-mega", "sableye-mega", "altaria-mega", "gallade-mega", "audino-mega", "sharpedo-mega", "slowbro-mega", "steelix-mega", "pidgeot-mega", "glalie-mega", "diancie-mega", "metagross-mega", "kyogre-primal", "groudon-primal", "rayquaza-mega", "pikachu-rock-star", "pikachu-belle", "pikachu-pop-star", "pikachu-phd", "pikachu-libre", "pikachu-cosplay", "hoopa-unbound", "camerupt-mega", "lopunny-mega", "salamence-mega", "beedrill-mega", "rattata-alola", "raticate-alola", "raticate-totem-alola", "pikachu-original-cap", "pikachu-hoenn-cap", "pikachu-sinnoh-cap", "pikachu-unova-cap", "pikachu-kalos-cap", "pikachu-alola-cap", "raichu-alola", "sandshrew-alola", "sandslash-alola", "vulpix-alola", "ninetales-alola", "diglett-alola", "dugtrio-alola", "meowth-alola", "persian-alola", "geodude-alola", "graveler-alola", "golem-alola", "grimer-alola", "muk-alola", "exeggutor-alola", "marowak-alola", "greninja-battle-bond", "greninja-ash", "zygarde-10", "zygarde-50", "zygarde-complete", "gumshoos-totem", "vikavolt-totem", "oricorio-pom-pom", "oricorio-pau", "oricorio-sensu", "lycanroc-midnight", "wishiwashi-school", "lurantis-totem", "salazzle-totem", "minior-orange-meteor", "minior-yellow-meteor", "minior-green-meteor", "minior-blue-meteor", "minior-indigo-meteor", "minior-violet-meteor", "minior-red", "minior-orange", "minior-yellow", "minior-green", "minior-blue", "minior-indigo", "minior-violet", "mimikyu-busted", "mimikyu-totem-disguised", "mimikyu-totem-busted", "kommo-o-totem", "magearna-original"
  )))

# get evolutions ----------------------------------------------------------











