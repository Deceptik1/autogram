def generate_whitelist
  # whitelist will get all of the people you follow, then compare it to the
  # list of people autogram has added. This way you can follow people, and not
  # worry about autogram deleting them
  navigate_to_profile
  following = get_following
  auto_following = @auto_following.keys
  whitelist = following - auto_following
  File.open('test/config/whitelist.yml', 'w+') do |f|
    f.write whitelist.to_yaml
  end
  return whitelist
end

def update_greylist
  # this is going to check all accounts in the greylist to see if they have
  # started to follow the account. If so, they will be removed from the greylist
  # and added to the greenlist
  navigate_to_profile
  followers = get_followers
  greylist = @greylist.keys
  greylist = greylist - followers
  new_greylist = Hash.new

  greylist.each do |i|
    new_greylist[i] = @greylist[i]
  end
  File.open('test/config/greylist.yml', 'w+') do |f|
    f.write new_greylist.to_yaml
  end
  return new_greylist
end

def load_greylist
  # this loads everyone you follow
  puts "----------------------------------------"
  puts "#{@greylist}: #{@greylist.size}"
  puts "----------------------------------------"
  new_greylist = Hash.new
  new_following = Hash.new

  navigate_to_profile
  puts "----------------------------------------"
  puts "nav"
  puts "----------------------------------------"
  following = get_following

  @greylist.each do |k,v|
    if following.include? k
      new_greylist[k] = @greylist[k]
      following.delete(k)
    end
  end

  following.each do |v|
    new_following[v] = following[v]
  end

  @greylist = new_greylist.merge(new_following)
  puts "----------------------------------------"
  puts "#{@greylist}: #{@greylist.size}"
  puts "----------------------------------------"

  File.open('test/config/greylist.yml', 'w+') do |f|
    f.write new_greylist.to_yaml
  end
end

def load_tags
  # This loads the tags string from the properties file, and seperates it into
  # an array
  tags = @properties["tags"].gsub(/\s+/m, ' ').strip.split(" ")
  return tags
end
