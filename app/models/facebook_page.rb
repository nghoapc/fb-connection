class FacebookPage < ApplicationRecord
	validates :page_id, uniqueness: { allow_nil: true }
end
