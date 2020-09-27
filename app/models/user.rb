class User < ApplicationRecord
  has_many :topics
  has_many :records
end
