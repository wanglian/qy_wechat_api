# encoding: utf-8
module QyWechatApi
  module Api
    class ShakeAround < Base

      # 获取设备及用户信息
      def get_shake_info(ticket)
        http_post("getshakeinfo", {ticket: ticket})
      end

      private

        def base_url
          "/shakearound"
        end
    end
  end
end