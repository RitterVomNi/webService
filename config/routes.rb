Rails.application.routes.draw do
  resources :messages
  resources :users

  scope '/:login' do
    get '/' => 'users#anmelden'
    post '/' => 'users#create'
    delete '/' => 'users#destroy'
    scope '/pubkey' do
      get '/' => 'users#pubkey'
    end
    scope '/message' do
      get '/' => 'messages#abholen'
      post '/' => 'messages#create'
      delete '/' => 'messages#destroy'
    end
  end


end
