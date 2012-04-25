require 'date'
require 'ostruct'

module CloudApp
  class Drop < OpenStruct
    attr_accessor :href, :data

    def initialize(collection_item)
      @href  = collection_item.href
      @links = collection_item.links
      @data  = collection_item.data
      super @data
    end

    def name()     super || share_url   end
    def private?() private == true      end
    def public?() !private?             end
    def created() DateTime.parse(super) end

    def share_url()     link_for_relation('canonical') end
    def thumbnail_url() link_for_relation('icon')      end
    def embed_url()     link_for_relation('embed')     end
    def download_url()  link_for_relation('download')     end

  protected

    def link_for_relation(relation)
      link = @links.find {|link| link.rel == relation }
      link and link.href
    end
  end
end
