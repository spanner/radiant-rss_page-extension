module RssTags
  include Radiant::Taggable
  require 'rss/maker'
  
  class TagError < StandardError; end

  desc %{
    This tag builds an RSS feed based on the tree of pages beneath the present page (which will usually have been shifted with r:find). If your blog page is at /blog, for example, then this:
    
    <pre><code><r:find url="/blog"><r:rss /></r:find></code></pre>
    
    is your blog feed. Yyou can get slightly more complicated if you want to:
    
    <pre><code><r:rss limit="20" format="0.9" title="Matters" subtitle="of great importance">Description can go here or in a 'description' page part.</r:rss></code></pre>

    but that's about it. If you just do this:
    
    <pre><code><r:find url="/"><r:rss /></r:find></code></pre>
    
    You get a site feed. In that case we'll default to the name of the site as the name of the feed, but usually it gets the name of the root page.
      
    # If you have paperclipped installed, each feed entry will include the first image asset attached to that page.
  }
  tag 'rss' do |tag|

    raise TagError, "can't have a feed without a page" unless page = tag.locals.page
    base_url = "http://" + (Page.respond_to?(:current_site) ? Page.current_site.base_domain : Radiant::Config['site.url'])
    defaults = {
      'format' => '2.0',
      'title' => page.title,
      'subtitle' => "",
      'author' => page.created_by.name,
      'email' => page.created_by.email,
      'keywords' => page.keywords,
      'language' => 'en-US',
      'copyright' => "",
      'image' => "",
      'link' => base_url + page.url,
      'offset' => 0,
      'limit' => 20,
      'by' => 'published_at',
      'order' => 'desc'
    }
    defaults.each {|k,v| tag.attr[k] ||= v}
    
    if tag.double?
      tag.attr['description'] = tag.expand
    elsif page.part(:description)
      tag.attr['description'] = page.render_part(:description)
    end
    
    tag.attr['description'] ||= "Nondescript."
        
    tag.locals.entries = []
    page.descendants({:limit => tag.attr['limit'], :offset => tag.attr['offset'], :order => "#{tag.attr['by']} #{tag.attr['order']}" }).each do |child|
      if child.class == Page && child.layout.content_type.blank? || child.layout.content_type == 'text/html'  # lazy way to skip error pages, stylesheets etc
        description = child.part(:description) ? child.render_part( :description ) : child.render_part( :body ) rescue nil
        tag.locals.entries.push({
          :title => child.title,
          :description => description,
          :link => base_url + child.url, 
          :date => child.published_at.utc   # RSS module doesn't like ActiveSupport::TimeWithZone
        })
      end
    end
    render_feed(tag)
  end

  protected

    def render_feed(tag)
      attr = tag.attr.symbolize_keys
      
      feed = RSS::Maker.make(attr[:format]) do |m|
        m.channel.title = attr[:title]
        m.channel.subtitle = attr[:subtitle]
        m.channel.link = attr[:link]
        m.channel.description = attr[:description]
        m.channel.copyright = attr[:copyright]
        m.channel.language = attr[:language]
        m.channel.author = attr[:author]
                
        latest_entry_date = tag.locals.page.published_at.utc  # the root page is probably old but gives us a starting point
        tag.locals.entries.each do |page|
          STDERR.puts "!!! rendering rss entry for #{page[:title]}: latest_entry_date is #{latest_entry_date} and entry date will be #{page[:date]}"
          latest_entry_date = page[:date] unless latest_entry_date && latest_entry_date >= page[:date]
          item = m.items.new_item
          item.title = page[:title]
          item.description = page[:description]
          item.link = page[:link]
          item.guid.content = page[:link]
          item.guid.isPermaLink = false
          item.date = page[:date]
        end
        
        m.items.do_sort = false
        m.channel.lastBuildDate = latest_entry_date
      end
      
      feed.to_s
    end
    
end
