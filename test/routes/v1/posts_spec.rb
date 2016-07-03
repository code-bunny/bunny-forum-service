# frozen_string_literal: true
require_relative '../../test_helper'

class ApiV1PostsTest < ApiV1TestCase
  let(:post) { Post.new }

  describe 'GET /posts' do
    before do
      Post.expects(:all).returns([post])
    end

    it 'should return 1 post' do
      get '/api/posts'

      assert_equal 1, json_response[:data].size
      assert_equal 200, status_code
    end
  end

  describe 'GET /posts/:id' do
    context 'when post exists' do
      before do
        Post.expects(:find).with('1').returns(post)
      end

      it 'should return 1 post' do
        get '/api/posts/1'

        assert_equal 1, json_response.size
        assert_equal 200, status_code
      end
    end

    context 'when post no found' do
      before do
        Post.expects(:find).with('1').raises(ActiveRecord::RecordNotFound)
      end

      it 'should return error message 404 post not found' do
        get '/api/posts/1'

        assert_equal 'Post not found.', json_response[:error]
        assert_equal 404, status_code
      end
    end
  end
end
