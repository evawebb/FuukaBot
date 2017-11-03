require "json"

eps = JSON.parse(File.open("fplus.json", "r").read)
better_tags = {}
eps.each do |k, v|
  if k != "tags"
    v.each do |t|
      if better_tags.has_key?(t)
        better_tags[t] += 1
      else
        better_tags[t] = 1
      end
    end
  end
end
eps["tags"] = better_tags
File.open("fixed_fplus.json", "w") do |f|
  f << JSON.generate(eps)
end
