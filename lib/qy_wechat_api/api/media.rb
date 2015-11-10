# encoding: utf-8

module QyWechatApi
  module Api
    class Media < Base

      # 媒体文件类型，分别有图片（image）、语音（voice）、视频（video），普通文件(file)
      # media: 支持传路径或者文件实例
      def upload(media, media_type)
        file = process_file(media)
        http_post("upload", {media: file}, {type: media_type})
      end

      # 返回一个URL，请开发者自行使用此url下载
      def get_media_by_id(media_id)
        "#{ENDPOINT_URL}#{base_url}/get?access_token=#{access_token}&media_id=#{media_id}"
      end

      private

      def base_url
        "/media"
      end
    end
  end
end
