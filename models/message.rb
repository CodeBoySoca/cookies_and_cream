class Message < ActiveRecord::Base
  def retrieve_message()
  end

  def retrieve_messages(recipient_id)
  end

  def send_message(sender_id, recipient_id)
  end

  def delete_message()
  end

  def delete_all_message()
  end

end
