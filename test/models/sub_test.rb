# == Schema Information
#
# Table name: subs
#
#  id          :integer          not null, primary key
#  name        :string           default(""), not null
#  title       :string           default(""), not null
#  description :string
#  creator_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class SubTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
