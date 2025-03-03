# This controller help run console commands in the admin app only develop and staging
# rubocop:disable Rails/RenderInline

module Admin
  class ConsoleController < BaseController
    def index
      console
      render inline: <<~HTML
        <div style="position: fixed; top: 0; left: 0; width: 100%; background-color: #fff; z-index: 1000; border-bottom: 1px solid #ddd; padding: 20px 0;">
          <div style="font-family: Arial, sans-serif; text-align: center;">
            <h1 style="font-size: 36px; font-weight: bold; margin: 0;">
              Web Console
            </h1>
            <p style="font-size: 16px; color: #FF5722; margin: 10px 0; font-weight: bold;">
              Please use this console with caution! It provides direct access to the database.
              <br>
              Any changes made here will take immediate effect and may be irreversible.
            </p>
            <a href="/admin" style="font-size: 16px; color: #007BFF; text-decoration: none;">
              &larr; Back to Home
            </a>
          </div>
        </div>
        <div class="console" style="margin-top: 150px; padding: 15px;">
          <!-- The console content goes here -->
        </div>
        <style>
          .console {
            height: calc(100% - 180px);
          }
        </style>
      HTML
    end
  end
end

# rubocop:enable Rails/RenderInline
