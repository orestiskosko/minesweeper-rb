require 'sinatra'
require './mine_game'
require 'json'
require 'pp'

$games = Hash.new

get '/' do
    game = MineGame.new(10)
    $games[game.id] = game
    pp request.env
    is_hx_request = request.env['HTTP_HX-REQUEST']
    pp is_hx_request

    logger.info "Is HX Request: #{is_hx_request}"

    if (is_hx_request)
        return erb :end_game, locals: { game: game }
    else
        return erb :index, locals: { id: game.id }
    end
end

post '/game/:id/reveal' do
    x = params['x'].to_i
    y = params['y'].to_i
    id = params['id'].to_i
    game = $games[id]
    game.reveal_tile(x, y)

    return erb :end_game, locals: { game: game }
end

