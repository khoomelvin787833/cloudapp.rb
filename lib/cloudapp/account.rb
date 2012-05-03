require 'forwardable'

# Usage:
#
#   # Create a new service passing CloudApp account token:
#   account = CloudApp::Account.using_token token
#
#   # Newest drops
#   account.drops                   #=> Active drops
#   account.drops(filter: :active)  #=> Active drops
#   account.drops(filter: :trash)   #=> Trashed drops
#   account.drops(filter: :all)     #=> All active and trashed drops
#
#   # List specific page of drops:
#   page1 = account.drops
#   page2 = account.drops href: page1.link('next')
#   page1 = account.drops href: page2.link('previous')
#   page1 = account.drops href: page1.link('self')
#
#   # View specific drop:
#   account.drop_at drop.href
#
#   # Create a bookmark:
#   account.bookmark 'http://getcloudapp.com'
#   account.bookmark 'http://getcloudapp.com', name: 'CloudApp'
#   account.bookmark 'http://getcloudapp.com', private: false
#
#   # Upload a file:
#   account.upload #<Pathname>
#   account.upload #<Pathname>, name: 'Screen shot'
#   account.upload #<Pathname>, private: false
#
#   # Update a drop:
#   account.update drop.href, name: 'CloudApp'
#   account.update drop.href, private: false
#
#   # Trash a drop:
#   account.trash_drop 42
#
#   # Recover a drop from the trash:
#   account.recover_drop 42
#
#   # Delete a drop:
#   account.delete_drop 42
#
#   # TODO: Newest 5 drops
#   account.drops limit: 5
#
module CloudApp
  class Account
    extend Forwardable
    def_delegators :service, :drops, :drop_at, :bookmark, :upload, :update,
                   :trash_drop, :recover_drop, :delete_drop

    class << self
      attr_writer :service_source

      def service_source
        @service_source ||= CloudApp::Service.public_method(:new)
      end

      def service
        service_source.call
      end
    end

    def initialize(token = nil)
      @token = token
    end

    def self.using_token(token)
      CloudApp::Account.new token
    end

  protected

    def service
      @service ||= self.class.service.tap do |service|
        service.token = @token if @token
      end
    end
  end
end
