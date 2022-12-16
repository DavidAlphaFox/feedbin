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
        signature, encoded_url = Icon.signed_url(url).split("/").last(2)
        get :show, params: {signature: signature, url: encoded_url}
        assert_response :not_found
      end

      test "should be redirect without icon bucket" do
        Icon.stub_const(:BUCKET, nil) do
          authorize
          url = "http://example.com/image.jpeg"
          signature, encoded_url = Icon.signed_url(url).split("/").last(2)
          get :show, params: {signature: signature, url: encoded_url}
          assert_redirected_to url
        end
      end

      test "should get proxy redirect" do
        authorize
        url = "http://example.com/image.jpeg"
        signature, encoded_url = Icon.signed_url(url).split("/").last(2)

        assert_difference -> { ImageCrawler::FindImage.jobs.size }, +1 do
          get :show, params: {signature: signature, url: encoded_url}
          assert_response :success
        end

        assert_equal "#{ENV["CAMO_HOST"]}/#{signature}/#{encoded_url}", response.header[IconsController::URL_HEADER]
        assert_equal "400", response.header[IconsController::SIZE_HEADER]
        assert response.header[IconsController::SENDFILE_HEADER].start_with?(IconsController::PROXY_PATH)
      end

      test "should get storage redirect" do
        authorize
        url = "http://example.com/image.jpeg"
        storage_url = "http://aws.amazonaws.com/asdf/asdfasf"
        icon = Icon.create!(fingerprint: Icon.fingerprint(url), original_url: url, storage_url: storage_url)

        signature, encoded_url = Icon.signed_url(url).split("/").last(2)

        get :show, params: {signature: signature, url: encoded_url}
        assert_response :success

        assert_equal storage_url, response.header[IconsController::URL_HEADER]
        assert_equal "400", response.header[IconsController::SIZE_HEADER]
        assert response.header[IconsController::SENDFILE_HEADER].start_with?(IconsController::PROXY_PATH)
      end

      test "should create an icon" do
        authorize
        image_url = "http://example.com/image.jpg"
        signature, encoded_url = Icon.signed_url(image_url).split("/").last(2)

        stub_request_file("image.jpeg", image_url, headers: {content_type: "image/jpeg"})
        stub_request(:put, /s3\.amazonaws\.com/).to_return(status: 200, body: aws_copy_body)

        Sidekiq::Testing.inline! do
          get :show, params: {signature: signature, url: encoded_url}
          assert_response :success
        end

        icon = Icon.find_by!(fingerprint: Icon.fingerprint(image_url))
        assert_equal(image_url, icon.original_url)
        assert_equal("https:", icon.storage_url)

        assert_requested :get, image_url
      end

      private

      def authorize
        @request.headers[IconsController::AUTH_HEADER] = ENV["ICON_AUTH_KEY"]
      end
    end
  end
end

