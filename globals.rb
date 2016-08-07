HIGH_ROLE = "Best Girl"
LOW_ROLE = "Worst Girl"
PREFIX = ";"
MESSAGE_LIMIT = 1000

srand

def access_denied(event)
  event.respond("You don't have privileges for that!")
end

def get_plevel(user)
  role_names = user.roles.map { |r| r.name }
  if role_names.include?(HIGH_ROLE)
    2
  elsif role_names.include?(LOW_ROLE)
    0
  else
    1
  end
end
