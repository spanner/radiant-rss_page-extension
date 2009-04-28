class RssFeedPage < Page

  description %{
    RSS Feed pages render a - no wait - rss feed. They don't do much but give it the proper content type.
  }
  
  def layout
    rss_layout = Layout.find_by_name('RSS') || Layout.create!({:name => 'RSS', :content_type => 'application/rss+xml', :content => '<r:content />'})
    update_attribute(:layout_id, rss_layout.id) if rss_layout && layout_id != rss_layout.id
    rss_layout
  end

end