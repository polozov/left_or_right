# == Schema Information
#
# Table name: users_roles
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  role_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe UsersRole do

  # ActiveRecord
  it { should belong_to(:user) }
  it { should belong_to(:role) }
  it { should have_db_index(:user_id) }
  it { should have_db_index(:role_id) }

end
