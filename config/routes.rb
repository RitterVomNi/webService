Rails.application.routes.draw do


  scope '/:login' do
    get '/' => 'users#anmelden'
    post '/' => 'users#create'
    delete '/' => 'users#destroy'
    scope '/pubkey' do
      get '/' => 'users#pubkey'
    end
    scope '/message' do
      get '/' => 'messages#letzte_abholen'
      post '/' => 'messages#create'
      delete '/:id' => 'messages#destroy_single'
    end
    scope '/messages' do
      get '/' => 'messages#alle_abholen'
      delete '/' => 'messages#destroy_all'
    end
  end


end
