class API::PokemonsController < ApplicationController
    def index
        page = !!query_params["page"] ? query_params["page"].to_i : 1
        per_page = !!query_params["per_page"] ? query_params["per_page"].to_i : 20
        start_index = (page - 1) * per_page
        end_index = start_index + per_page
        if page > 1
            start_index = start_index + 1
        end
        pokemon_list = Pokemon.where(id: [start_index..end_index])
        pokemon_list = pokemon_list.map do |pokemon|
            pokemon_json = pokemon.as_json
            pokemon_json["image_url"] = pokemon.image.url
            pokemon_json.except("created_at", "updated_at")
        end
        response = {
            count: Pokemon.count,
            page: page,
            per_page: per_page,
            results: pokemon_list
        }
        render json: response.to_json
    end

    def create
        # TODO: implement with pseudocode below
    end

    def edit
        # TODO: implement with pseudocode below
    end

    private 

    def pokemon_params
        params.require(:pokemon).permit(:name, :image)
    end

    def query_params
        request.query_parameters
    end
end
