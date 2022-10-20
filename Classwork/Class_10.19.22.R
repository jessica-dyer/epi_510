##Purpose of Script: Classwork 
##Date: 10.19.22
##---------------------
library(tidyverse)
library(haven)
install.packages("gapminder")
library("gapminder")
gapminder
filter(gapminder, country=="Afghanistan")
filter(gapminder, country=="Afghanistan" & year>2000)
gapminder %>% filter(country=="Afghanistan" & year>2000)
afg2000 <- gapminder %>% filter(country=="Afghanistan" & year>2000)
gapminder %>% filter(continent=="Oceania" & year>1980)
gapminder %>% select(country, year, lifeExp) %>% names()
gapminder %>% select(country, year, gdpPercap)

##sort by life expectancy- shortest life expectancy 
gapminder %>% select(country, year, lifeExp) %>% arrange(lifeExp)

##sort by life expectancy- longest life expectancy 
gapminder %>% select(country, year, lifeExp) %>% arrange(desc(lifeExp))

##another way of organizing by descending order
tail(gapminder %>% select(country, year, lifeExp) %>% arrange(lifeExp))

##creating new column
gapminder <- gapminder %>% mutate(gdp = gdpPercap*pop)

##Create a high GDP per capita variable that is 1/TRUE where gdpPercap is greater than the mean value of gdpPercap, and 0/FALSE when less than or equal to the mean 
gapminder <- gapminder %>% mutate(highGdpPc = gdpPercap>mean(gdpPercap))
