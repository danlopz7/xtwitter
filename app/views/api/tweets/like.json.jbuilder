if @liked.valid?
    json.message "Tweet liked successfully"
  else
    json.errors @liked.errors.full_messages
  end
  