# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  token      :string           not null
#  user_id    :integer          not null
#  post_id    :integer          not null
#  parent_id  :integer
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Comment < ActiveRecord::Base
  acts_as_tree
  acts_as_votable

  before_create :randomize_token

  belongs_to :parent, :class_name => "Comment", :foreign_key => "parent_id", touch: true
  belongs_to :post, touch: true
  belongs_to :user, touch: true

  validates :content, presence: true
  validates :user_id, presence: true
  validates :post_id, presence: true
  validates :token, presence: true

  private

    def randomize_token
      if self.token.nil?
        begin
          self.token = SecureRandom.urlsafe_base64(5, false)
        end while Comment.where(:token => self.token).exists?
      end
    end
end
