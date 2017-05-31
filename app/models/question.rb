class Question < ApplicationRecord
  # scope :status, -> (status) { where status: status }
  validates :title, presence: true
  validates :body, presence: true
  validates :language, presence: true
  belongs_to :student
  has_many :votes
  has_one :response
  has_one :rate, through: :response


  scope :resolved, -> () { joins(:response).where("responses.status = 'true'").includes(:response).includes(:student) }
  scope :unclaimed, -> { where.not(:id => Response.select(:question_id).uniq).includes(:response).includes(:student) }
  scope :resolvedByMentor, -> (mentor_id) {joins(response: :mentor).where("responses.mentor_id = #{mentor_id}").includes(:response).includes(:rate).includes(:student)}
  


end
