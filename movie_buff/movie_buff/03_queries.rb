def what_was_that_one_with(those_actors)
  # Find the movies starring all `those_actors` (an array of actor names).
  # Show each movie's title and id.
  Movie
    .select(:id, :title)
    .joins(:actors)
    .group(:id)
    .where(actors: { name: those_actors })
    .having('COUNT(actors.id) = ?', those_actors.length)
end

def golden_age
  # Find the decade with the highest average movie score.
  Movie
    .group('decade')
    .order('AVG(score) DESC')
    .limit(1)
    .pluck('((yr / 10) * 10) AS decade').first
end

def costars(name)
  # List the names of the actors that the named actor has ever
  # appeared with.
  # Hint: use a subquery
  print name
  movies_with_name = Movie
    .joins(:actors)
    .where('actors.name = ?', name)
    .pluck(:id)

  Actor
    .joins(:castings)
    .where('castings.movie_id IN (?)', movies_with_name)
    .where.not('actors.name = ?', name)
    .pluck(:name)

end

def actor_out_of_work
  # Find the number of actors in the database who have not appeared in a movie
  Actor
    .joins('LEFT JOIN castings ON actors.id = castings.actor_id')
    .where('castings.actor_id IS NULL')
    .pluck('COUNT(*)').first
end

def starring(whazzername)
  # Find the movies with an actor who had a name like `whazzername`.
  # A name is like whazzername if the actor's name contains all of the
  # letters in whazzername, ignoring case, in order.

  # ex. "Sylvester Stallone" is like "sylvester" and "lester stone" but
  # not like "stallone sylvester" or "zylvester ztallone"
  whazzername = "%#{whazzername.split('').join('%')}%"
  puts whazzername
  Movie
    .joins(:actors)
    .where("UPPER(actors.name) LIKE UPPER(?)", whazzername)
end

def longest_career
  # Find the 3 actors who had the longest careers
  # (the greatest time between first and last movie).
  # Order by actor names. Show each actor's id, name, and the length of
  # their career.
  Actor
    .select(:id, :name, 'MAX(movies.yr) - MIN(movies.yr) AS career')
    .joins(:movies)
    .group(:id)
    .order('career DESC, name')
    .limit(3)
end
