Rails.application.routes.draw do
  get 'score',       to: 'longestword#score'
  get 'game',     to: 'longestword#game'

  root to: 'longestword#game'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
