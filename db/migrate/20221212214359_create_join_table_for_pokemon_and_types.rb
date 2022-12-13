class CreateJoinTableForPokemonAndTypes < ActiveRecord::Migration[7.0]
  def change
    create_join_table :pokemons, :types do |t|
      t.index [:pokemon_id, :type_id]
    end
  end
end
