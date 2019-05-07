module RelationshipsHelper
  def create_follower
    current_user.active_relationships.build
  end

  def load_idol user_id
    current_user.active_relationships.find_by idol_id: user_id
  end
end
