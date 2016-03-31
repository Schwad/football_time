require "mechanize"
require "pry"

#This is the mac version.

`say This program will behave correctly if you send it the appropriate style BBC link copied directly from the game page. In future we hope to have it take in all games on a specified page.`

#USER INPUT

puts "Welcome to football tracker, enter the BBC Sport games you would like to track today with copy paste, then hit enter. \n\nWhen you are happy, start the program by entering 'GO' then enter again"

start_program = nil
links = []

while start_program != 'GO'
  puts "Another link? \n"

  new_link = gets.chomp
  if new_link == 'GO'
    start_program = 'GO'
  else
    links << new_link
  end

end

def play_my_audio(team_one, team_one_score, team_two, team_two_score)
  puts "HIT! #{team_one}"
  `say Attention, we have a new score update from #{team_one}`
  sleep 1.5
  `say #{team_one} #{team_one_score}, #{team_two} #{team_two_score}`
end

#PRE LOOP SETUP CODE GOES IN HERE TO ESTABLISH EXISTING VARIABLES IN A HASH
all_games = Hash.new
counter = 0
links.each do |link|
  a=Mechanize.new
  a=a.get(link)
  home_team = a.search("span.fixture__team-name--home")[0].text
  away_team = a.search("span.fixture__team-name--away")[0].text
  all_games[counter] = Hash.new
  all_games[counter]["home_team"] = 0
  all_games[counter]["away_team"] = 0
  all_games[counter]["home_team_name"] = home_team
  all_games[counter]["away_team_name"] = away_team
  all_games[counter]["main_link"] = link
  counter += 1
end

#FUNCTIONALITY

while true

  all_games.keys.each do |key|
    puts "Now checking #{all_games[key]["home_team_name"]} vs #{all_games[key]["away_team_name"]}"
    a=Mechanize.new
    a=a.get(all_games[key]["main_link"])
    if a.search("span.fixture__number--home")[0].text.to_i != all_games[key]["home_team"]
      all_games[key]["home_team"] = a.search("span.fixture__number--home")[0].text.to_i
      play_my_audio(all_games[key]["home_team_name"], all_games[key]["home_team"], all_games[key]["away_team_name"], all_games[key]["away_team"])
    elsif a.search("span.fixture__number--away")[0].text.to_i != all_games[key]["away_team"]
      all_games[key]["away_team"] = a.search("span.fixture__number--home")[0].text.to_i
      play_my_audio(all_games[key]["home_team_name"], all_games[key]["home_team"], all_games[key]["away_team_name"], all_games[key]["away_team"])
    end
  end
end
