library(rvest)
library(cronR)
library(dplyr)
library(rsconnect)

#### Scrape Table ####
# load webpage
url = "https://www.premierleague.com/tables"
webpage = read_html(url)

# scrape table
#team names
teams_html = html_nodes(webpage, ".long")
teams = html_text(teams_html)

# rankings
rankings_html = html_nodes(webpage, ".value")
rankings = html_text(rankings_html)

# games played
gp_html = html_nodes(webpage, "td:nth-child(4)")
gp = html_text(gp_html)

# wins
wins_html = html_nodes(webpage, "td:nth-child(5)")
wins = html_text(wins_html)

# draws
draws_html = html_nodes(webpage, "td:nth-child(6)")
draws = html_text(draws_html)

# losses
losses_html = html_nodes(webpage, "td:nth-child(7)")
losses = html_text(losses_html)

# goals for
gf_html = html_nodes(webpage, "td:nth-child(8)")
gf = html_text(gf_html)

# goals against
ga_html = html_nodes(webpage, "td:nth-child(9)")
ga = html_text(ga_html)

# goal diff
gd_html = html_nodes(webpage, "td:nth-child(10)")
gd = html_text(gd_html)

# points
points_html = html_nodes(webpage, "td:nth-child(11)")
points = html_text(points_html)

# create table as a df
table = data.frame(rank = rankings,
                   team = teams,
                   games_played = gp,
                   wins = wins,
                   losses = losses,
                   draws = draws,
                   goals_for = gf,
                   goals_against = ga,
                   goal_diff = gd,
                   points = points)
row.names(table) = NULL

# clean up table
table$goal_diff = gsub("\n", "", table$goal_diff)

# drop championship teaams
epl_table = table[-c(21:80),]

# format table
epl_table = epl_table %>% 
  mutate_at(c("rank", "games_played", "wins", "losses", "draws", "goals_for", "goals_against", "goal_diff", "points"), as.character) %>% 
  mutate_at(c("rank", "games_played", "wins", "losses", "draws", "goals_for", "goals_against", "goal_diff", "points"), as.numeric) %>% 
  mutate_at(c("team"), as.character())

# order table by rank
epl_table = epl_table[order(epl_table$rank),]

##### Draft Results ####
# draft results
owners = c("Jason", "Casey", "Megan", "CB", "Neo")

# jason teams
#jason_teams20/21 = c("Manchester City", "Southampton", "Leeds United", "West Bromwich Albion")
jason_teams = c("Liverpool", "Tottenham Hotspur", "Wolverhampton Wanderers", "Brentford")
jteams_str = paste( unlist(jason_teams), collapse=', ')

# casey teams
#casey_teams20/21 = c("Liverpool", "Everton", "Sheffield United", "Fulham")
casey_teams = c("Manchester City", "Leeds United", "Everton", "Watford")
cteams_str = paste( unlist(casey_teams), collapse=', ')

# megan teams
#megan_teams20/21 = c("Chelsea", "Arsenal", "West Ham United", "Crystal Palace")
megan_teams = c("Leicester City", "West Ham United", "Crystal Palace", "Burnley")
mteams_str = paste( unlist(megan_teams), collapse=', ')

# cb teams
#cb_teams20/21 = c("Manchester United", "Wolverhampton Wanderers", "Burnley", "Brighton and Hove Albion")
cb_teams = c("Chelsea", "Aston Villa", "Brighton and Hove Albion", "Norwich City")
cbteams_str = paste( unlist(cb_teams), collapse=', ')

# neo teams
#neo_teams20/21 = c("Leicester City", "Tottenham Hotspur", "Newcastle United", "Aston Villa")
neo_teams = c("Manchester United", "Arsenal", "Southampton", "Newcastle United")
nteams_str = paste( unlist(neo_teams), collapse=', ')

# create new table
epl_table$owner = ""

# populate table with owner of each team
epl_table[epl_table$team %in% jason_teams,]$owner <- "Jason"
epl_table[epl_table$team %in% casey_teams,]$owner <- "Casey"
epl_table[epl_table$team %in% megan_teams,]$owner <- "Megan"
epl_table[epl_table$team %in% cb_teams,]$owner <- "CB"
epl_table[epl_table$team %in% neo_teams,]$owner <- "Neo"

# group by owner and sum points to create owner table
otable = epl_table %>% 
  group_by(owner) %>% 
  summarise(points = sum(points))

# order table by points
otable = data.frame(otable[order(otable$points, decreasing = T),])

epl_table$owner[epl_table$owner == "Neo"] <- "Neo ⭐"
otable$owner[otable$owner == "Neo"] <- "Neo ⭐"
epl_table$owner[epl_table$owner == "Megan"] <- "Megan ⭐"
otable$owner[otable$owner == "Megan"] <- "Megan ⭐"


# reformat headings
names(epl_table) = c("Rank", "Team", "GP", "W", "L", "D", "GF", "GA", "GD", "Points", "Manager")

names(otable) = c("Manager", "Points")

setwd("~/projects/ep-pool/epl-pool")

write.csv(epl_table, "epl_table.csv")
write.csv(otable, "owner_table.csv")

deployApp(forceUpdate = TRUE)

