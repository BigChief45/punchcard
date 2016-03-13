class Punchcard < ActiveRecord::Base
    belongs_to :user
    has_many :records, dependent: :destroy
    
    validates :name, :presence => true
    validates :icon, :presence => true
    
end