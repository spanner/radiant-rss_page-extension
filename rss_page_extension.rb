# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class RssPageExtension < Radiant::Extension
  version "0.1"
  description "Makes it easy to render an RSS feed"
  url "http://spanner.org/radiant/rss_page"
  
  # define_routes do |map|
  #   map.namespace :admin, :member => { :remove => :get } do |admin|
  #     admin.resources :podcast
  #   end
  # end
  
  def activate
    RssFeedPage
    Page.send :include, PageFamily
    Page.send :include, RssTags
  end
  
  def deactivate
    # admin.tabs.remove "Podcast"
  end
  
end
