module ApplicationHelper
	def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def flash_normal
 		render "flashes"
	end

	def twitterized_type(type)
		case type
			when :errors
				"alert-error"
			when :alert
				"alert-warning"
			when :error
				"alert-error"
			when :notice
				"alert-success"
			else
				"alert-info"
		end
	end

	def merge_params(p={})
  	params.merge(p).delete_if{|k,v| v.blank?}
	end

	# returns an ordered and filtered list of posts
  # initial scope, default to Post.all
  # tag = video tag
  # order = how the results are order
  # filter = filter to apply to posts
  def get_posts(initial_scope, tag, order, filter, running = true)
    if initial_scope.nil?
      posts = Post.all
    else
      posts = initial_scope
    end

    unless tag.blank?
      posts = posts.tagged_with(tag)
    end

    # apply scopes for ordering
    posts = posts.popular if order == "popular"
    posts = posts.newest if order == "newest"
    posts = posts.liked if order == "liked"

    # apply scopes for filtering
    posts = posts.last_week if filter == "week"
    posts = posts.last_month if filter == "month"

    # only return running videos
    if running
      #posts = posts.running
    end

    return posts
  end

  def get_filtered_title(initial, tag, order, filter)

    title = initial

    unless tag.blank?
      title = "#{title} tagged as #{tag}"
    end

    if order == "popular"
      title = "Popular #{title}"
    elsif order == "newest"
      title = "Newest #{title}"
    elsif order == "liked"
      title = "Liked #{title}"
    end

    if !filter.blank? && filter != "all" && order != "newest"
      title = "#{title} from the last #{filter}"
    end

    return title
  end

  def get_filter_url(controller, action, id)
    if controller == "users"
      if action == "manage"
        url = manage_user_path(id)
      else
        url = videos_user_path(id)
      end
    elsif controller == "channels"
      url = videos_channel_path(id)
    else
      url = videos_path
    end
    
    return url
  end
end
