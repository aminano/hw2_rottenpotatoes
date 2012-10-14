class Movie < ActiveRecord::Base
def self.find_ratings
  ['G', 'PG', 'PG-13', 'R']
  end
end
