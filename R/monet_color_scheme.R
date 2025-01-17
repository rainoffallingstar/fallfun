# WARNING - Generated by {fusen} from dev/flat_first.Rmd: do not edit by hand

#' monet_color_scheme
#' 
#' gen color scheme from monet's works or similar to material you
#' @param num_colors num the number of colors
#' @param randomgen logit generate color scheme randomly when true
#' @param seed num the set.seed() to keep reproducible sampling
#' 
#' @return vector
#' 
#' @export
#' @examples
#' monet_color_scheme(5)
monet_color_scheme <- function(num_colors = 5,
                               randomgen = FALSE,
                               seed = NULL) {
  monet_random_hcl <- function(num_colors) {
    hcl_df <- data.frame(
      h = runif(num_colors, min = 31, max = 360),
      c = c(runif(1, min = 13, max = 150),runif(num_colors-1, min = 3, max = 25)),
      l = c(runif(1, min = 7, max = 100),rep(60,num_colors-1))
      ) %>% 
      dplyr::mutate(color = hcl(h,c,l))
    return(hcl_df)
  }
  if (!is.null(seed)){
    set.seed(seed)
  }
  if (randomgen){
    random_colors <- monet_random_hcl(num_colors)
    colors <- random_colors$color
  }else{
    if (num_colors > 5){
      message("the scheme color from monet's art works should have a num_colors <= 5, try randomgen ...")
      random_colors <- monet_random_hcl(num_colors)
      colors <- random_colors$color
    }else{
      workid <- sample(1:1250,1)
      random_colors <- monet_color_df[workid,] %>% unlist()
      colors <- random_colors[-1]
      colors <- colors[1:num_colors]
      des <- monet %>% 
        dplyr::filter(id %in% random_colors)
      message(glue::glue("color from the work {des$title[1]} is used"))
    }
  }
  library(ggplot2)
  p <- data.frame(color_vector=colors ,
           num = rep(1,num_colors)) %>% 
    ggplot(aes(x = num, y = num)) + 
    geom_bar(stat = "identity", width = 0.7,fill = colors) + 
    theme_minimal() + 
    theme(axis.text.x = element_blank(), axis.title.x = element_blank(),
        axis.ticks.x = element_blank())
  print(p)
  return(colors)
}
