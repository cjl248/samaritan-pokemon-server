require 'open-uri'

namespace :database_operations do

  desc "Populates the pokemons table with data from the 'https://pokeapi.co/pokemon' API"
  task populate_pokemon: :environment do
    unless Pokemon.count == 0
      Pokemon.destroy_all 
      puts "Database and S3 client cleared"
      puts "Begin re-populating"
    end

    def add_pokemons_types_association(pokemon, full_pokemon_info)
      types_list = full_pokemon_info["types"]
      types_list.each do |type|
        type_name = type.dig("type", "name")
        type = Type.find_by(name: type_name)
        pokemon.types << type
      end
    end

    def add_pokemon(pokemon_list)
      pokemon_list.each_with_index do |pokemon, index|
        back_up_image_url = "https://images.unsplash.com/photo-1515041219749-89347f83291a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1674&q=80"
        pokemon_record = Pokemon.new(name: pokemon["name"])
        full_pokemon_info = HTTParty.get(pokemon["url"])
        picture_url = full_pokemon_info.dig("sprites", "other", "official-artwork", "front_default")
        picture_url = !!picture_url ? picture_url : back_up_image_url
        downloaded_image = URI.open(picture_url)
        pokemon_record.image.attach(io: downloaded_image, filename: "#{full_pokemon_info["id"]}.png")
        pokemon_record.save!
        add_pokemons_types_association(pokemon_record, full_pokemon_info)
        puts "Added pokemon ##{full_pokemon_info["id"]}"
      end
    end

    limit = 1154 # total = 1154

    response = HTTParty.get("https://pokeapi.co/api/v2/pokemon/?offset=0&limit=#{limit}")
    first_pokemon_list = response.parsed_response["results"]
    add_pokemon(first_pokemon_list)

    # can be used if limit < 1154 and smaller chunks at a time are faster
    # while response.parsed_response["next"]
    #   next_page = response.parsed_response["next"]
    #   response = HTTParty.get(next_page)
    #   data = response.parsed_response
    #   pokemon_list = data["results"]
    #   add_pokemon(pokemon_list)
    # end

    puts "All pokemon added successfully"
  end

  desc "Populates the types table with data from the 'https://pokeapi.co/type' API"
  task populate_types: :environment do
    Type.destroy_all unless Type.count == 0
    offset = "0"
    limit = "100"
    response = HTTParty.get("https://pokeapi.co/api/v2/type/?offset=#{offset}&limit=#{limit}")
    data = response.parsed_response
    results = data["results"]
    results_count = results.length  
    if data["next"] == nil
      results.each { |type| Type.create!(name: type["name"]) }
    else
      # TODO: implement once type results_count starts getting close to 100
    end
  end

end
