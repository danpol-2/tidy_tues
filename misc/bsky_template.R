
# setup -------------------------------------------------------------------

# API: https://christophertkenny.com/bskyr/index.html

# setwd("~/repos/tidy_tues/misc")

pacman::p_load(bskyr)


# examples --------------------------------------------------------------------

# bs_post("test post")
# 
# bs_post(text = "test post 2",
#         images = c("test_image.png"),
#         images_alt = c("test_image.png"))
# 
# bs_post(text = "I'd say so (test comment)",
#         reply = "https://bsky.app/profile/danpol2.bsky.social/post/3lm6fxvgdcd23")
# 
# bs_post(text = "I'd say so (again) (test quote)",
#         quote = "https://bsky.app/profile/danpol2.bsky.social/post/3lm6fxvgdcd23")
# 
# bs_repost(post = "https://bsky.app/profile/danpol2.bsky.social/post/3lm6fxvgdcd23")
