# encoding: utf-8

module QyWechatApi
  module Api
    class Base
      attr_accessor :access_token, :corp_id

      def initialize(access_token, corp_id=nil)
        @access_token = access_token
        @corp_id = corp_id
      end

      private

      def http_get(url, params={})
        params = params.merge({access_token: access_token})
        QyWechatApi.http_get_without_token(request_url(url, params), params )
      end

      def http_post(url, payload={}, params={})
        params = params.merge({access_token: access_token})
        QyWechatApi.http_post_without_token(request_url(url, params), payload, params)
      end

      def base_url
        ""
      end

      def request_url(url, params={})
        waive_base_url = params.delete(:waive_base_url)
        if waive_base_url
          url
        else
          # 使用基础 +base_url+进行拼接
          "#{base_url}/#{url}"
        end
      end

      def process_file(media)
        return media if media.is_a?(File) && jpep?(media)

        media_url = media
        uploader  = QyWechatApiUploader.new

        if http?(media_url) # remote
          uploader.download!(media_url.to_s)
        else # local
          media_file = media.is_a?(File) ? media : File.new(media_url)
          uploader.cache!(media_file)
        end
        file = process_media(uploader)
        CarrierWave.clean_cached_files! # clear last one day cache
        file
      end

      def process_media(uploader)
        uploader = covert(uploader)
        uploader.file.to_file
      end

      # JUST ONLY FOR JPG IMAGE
      def covert(uploader)
        # image process
        unless (uploader.file.content_type =~ /image/).nil?
          if !jpep?(uploader.file)
            require "mini_magick"
            # covert to jpeg
            image = MiniMagick::Image.open(uploader.path)
            image.format("jpg")
            uploader.cache!(File.open(image.path))
            image.destroy! # remove /tmp from MinMagick generate
          end
        end
        uploader
      end

      def http?(uri)
        return false if !uri.is_a?(String)
        uri = URI.parse(uri)
        uri.scheme =~ /^https?$/
      end

      def jpep?(file)
        content_type = if file.respond_to?(:content_type)
            file.content_type
          else
            content_type(file.path)
          end
        !(content_type =~ /jpeg/).nil?
      end

      def content_type(media_path)
        MIME::Types.type_for(media_path).first.content_type
      end
    end
  end
end
