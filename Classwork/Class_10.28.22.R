library(gapminder)
library(ggplot2)
library(tidyverse)

gapminder
ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) + geom_point()
ggplot(gapminder, aes(x = year, y = lifeExp)) + geom_point()
ggplot(gapminder, aes(x = year, y = lifeExp)) + geom_jitter()
gapminder %>% filter(year==2007) %>% ggplot(aes(x = gdpPercap, y = lifeExp)) + geom_point(aes(color = continent, size = pop)) + geom_smooth() +  scale_x_log10() 
gapminder %>% filter(continent=="Americas") %>% ggplot(aes(x = year, y = lifeExp)) + geom_point()
gapminder %>% filter(continent=="Americas") %>% ggplot(aes(x = year, y = lifeExp, size = pop)) + geom_jitter() + geom_smooth()
gapminder %>% ggplot(aes(x = year, y = lifeExp, size = pop, color = continent)) + geom_jitter() + geom_smooth()

gapminder %>% filter(continent=="Americas") %>% 
  ggplot(aes(x = gdpPercap, y = lifeExp)) + 
  geom_jitter(aes(color = country, size = pop)) + 
  geom_smooth() + scale_x_log10() + geom_line(aes(color=country)) 

##year specific plots
gapminder %>% 
  ggplot(aes(x = gdpPercap, y = lifeExp)) + 
  geom_jitter(aes(color = country, size = pop)) + 
  scale_x_log10() + geom_line(aes(color=country)) +
  facet_wrap(~continent) + guides(color = "none")

##
gapminder %>% group_by(continent, year) %>% 
  summarize(lifeExp = mean(lifeExp), popMillions = sum(pop/1000000)) %>%
  ggplot(aes(x = year, y = lifeExp, color=continent)) + 
  geom_line() + geom_point(aes(size = popMillions)) + scale_color_brewer(palette = "YlGnBu")

##bar chart
gapminder %>% group_by(year) %>% summarize(pop = sum(pop/1000000)) %>%
  ggplot(aes(x = year, y = pop)) + geom_col() + theme_minimal()

