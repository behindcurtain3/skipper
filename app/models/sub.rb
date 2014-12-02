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

class Sub < ActiveRecord::Base
  resourcify
  belongs_to :creator,
    class_name: "User",
    touch: true

  validates :name,
    presence: true,
    uniqueness: { case_sensitive: false },
    format: { with: /\A[a-zA-Z0-9]+\z/i },
    length: { minimum: 3, maximum: 42 }
  validates :title,
    presence: true,
    length: { maximum: 140 }
  validates :description,
    length: { maximum: 512 }

  has_many :posts
  has_many :active_subscriptions,
    class_name: "Subscription",
    foreign_key: "sub_id",
    dependent: :destroy
  has_many :subscribers,
    through: :active_subscriptions,
    source: :sub

  def to_param
    name
  end
end
