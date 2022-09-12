class Api::V1::UsersController < ApplicationController
    before_action :authenticate_with_token!, only: [:logout]

    def facebook
        if params[:facebook_access_token]
            graph = Koala::Facebook::API.new(params[:facebook_access_token])
            user_data = graph.get_object("me?fields=name, email, id, picture")

            user = User.find_by(email: user_data['email'])

            if user
                user.generate_authentication_token
                user.save
                render json: user, status: :ok
            else
                user = User.new(
                    fullname: user_data['fullname'],
                    email: user_data['email'],
                    uid: user-data['id'],
                    provider: 'Facebook',
                    image: user_data['picture']['data']['url']
                )

                user.generate_authentication_token

                if user.save
                    render json: user, status: :ok
                else
                    render json: {error:  user.errors, is_succes: false}, status: 422
                end
            end
        else
            render json: {error: "Invalid Facebook Token", is_succes: false}, status: :unprocessable_entity
        end
    end

    def logout
        user = User.find_by(access_token:  params[:access_token])
        #logger.debug {"Value of params" + params[:access_token]}

        user.generate_authentication_token
        user.save

        render json: {is_success: true}, status: :ok
    end

end