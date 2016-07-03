# frozen_string_literal: true
module Routes
  module V1
    class Posts < Grape::API
      version 'v1', using: :accept_version_header, vendor: 'cabbit'
      format :json
      content_type :json, 'application/json;charset=UTF-8'

      rescue_from ActiveRecord::RecordNotFound do
        error!({ error: 'Post not found.' }, 404, 'Content-Type' => 'text/error')
      end

      resource :posts do
        desc ''
        get do
          cache_control :public, max_age: 15

          posts = Post.all
          serialize(posts, is_collection: true)
        end

        route_param :id do
          get do
            cache_control :public, max_age: 15

            post = Post.find(params[:id])
            serialize(post, is_collection: false)
          end
        end
      end
    end
  end
end
