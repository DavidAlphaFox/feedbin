require "test_helper"

module Icons
  module V1
    class IconsControllerTest < IconsControllerTestCase
      setup do
        @user = users(:ben)
      end

      test "should be unauthorized without pull key" do
        get :show, params: {signature: "asdf", url: "asdf"}
        assert_response :not_found
      end

      test "should be unauthorized without valid signature" do
        authorize
        get :show, params: {signature: "asdf", url: "asdf"}
        assert_response :not_found
      end

      test "should be unauthorized without http url" do
        authorize
        url = "example.com/image.jpeg"
        _, signature, encoded_url = Icon.signed_path(url).split("/")
        get :show, params: {signature: signature, url: encoded_url}
        assert_response :not_found
      end

      test "should be redirect without icon bucket" do
        Icon.stub_const(:BUCKET, nil) do
          authorize
          url = "http://example.com/image.jpeg"
          _, signature, encoded_url = Icon.signed_path(url).split("/")
          get :show, params: {signature: signature, url: encoded_url}
          assert_redirected_to url
        end
      end

      test "should get proxy redirect" do
        authorize
        url = "http://example.com/image.jpeg"
        signed_path = Icon.signed_path(url)
        _, signature, encoded_url = signed_path.split("/")

        assert_difference -> { ImageCrawler::CacheIcon.jobs.size }, +1 do
          get :show, params: {signature: signature, url: encoded_url}
          assert_response :success
        end

        assert_equal "#{ENV["CAMO_HOST"]}#{signed_path}", response.header[IconsController::URL_HEADER]
        assert_equal "400", response.header[IconsController::SIZE_HEADER]
        assert response.header[IconsController::SENDFILE_HEADER].start_with?(IconsController::PROXY_PATH)
      end

      test "should get storage redirect" do
        authorize
        url = "http://example.com/image.jpeg"
        storage_url = "http://aws.amazonaws.com/asdf/asdfasf"
        icon = Icon.create!(fingerprint: Icon.fingerprint(url), original_url: url, storage_url: storage_url)

        signed_path = Icon.signed_path(url)
        _, signature, encoded_url = signed_path.split("/")

        get :show, params: {signature: signature, url: encoded_url}
        assert_response :success

        assert_equal storage_url, response.header[IconsController::URL_HEADER]
        assert_equal "400", response.header[IconsController::SIZE_HEADER]
        assert response.header[IconsController::SENDFILE_HEADER].start_with?(IconsController::STORAGE_PATH)
      end

      private

      def authorize
        @request.headers[IconsController::AUTH_HEADER] = ENV["ICON_AUTH_KEY"]
      end
    end
  end
end

