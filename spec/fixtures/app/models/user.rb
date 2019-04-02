class User < ActiveRecord::Base
  has_one :profile, foreign_key: :owner_id
  has_and_belongs_to_many :companies
end
