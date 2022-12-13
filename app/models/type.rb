class Type < ApplicationRecord
    has_and_belongs_to_many :pokemons, dependent: :destroy

    validates :name, presence: true, uniqueness: true

end