class RssFeedPage < Page

  description %{
    RSS Feed pages render a - no wait - rss feed with the proper content type.
  }
  
  def self.sphinx_indexes
    []
  end
  
  def layout
    Layout.find(layout_id)
  rescue ActiveRecord::RecordNotFound
    rss_layout = Layout.find_by_name('RSS') || Layout.create!({:name => 'RSS', :content_type => 'application/rss+xml', :content => '<r:content />'})
    update_attribute(:layout_id, rss_layout.id) if rss_layout
    rss_layout
  end

end