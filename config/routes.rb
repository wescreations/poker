Rails.application.routes.draw do

get 'poker/main'
post 'poker/submit_hand'
root 'poker#main'

end
