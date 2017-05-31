class Question < ApplicationRecord
  # scope :status, -> (status) { where status: status }
  validates :title, presence: true
  validates :body, presence: true
  validates :language, presence: true
  belongs_to :student
  has_many :votes
  has_one :response

  scope :resolved, -> () { joins(:response).where("responses.status = 'true'").includes(:response) }
  scope :claimed, -> () { joins(:response).where("responses.status = 'false'").includes(:response) }
  scope :unclaimed, -> () { where.not(:id => Response.select(:question_id).uniq).includes(:response) }
  scope :resolvedByMentor, -> (mentor_id) {joins(response: :mentor).where("responses.mentor_id = #{mentor_id}").includes(:response)}

  def status
      if response
        if response.status == true
          'resolved'
          # response.status == false && questinon.response.mentor_id == mentor_id 
        else
          'claimed'
        end
      else
        'unclaimed'
      end
  end

end
