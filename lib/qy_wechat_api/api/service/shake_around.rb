# encoding: utf-8
module QyWechatApi
  module Api
    module Service
      class ShakeAround < ServiceBase
        # 获取设备及用户信息
        def get_shake_info(ticket)
          http_post("getshakeinfo", {ticket: ticket})
        end

        private

          def base_url
            "/service"
          end
      end
    end
  end
end