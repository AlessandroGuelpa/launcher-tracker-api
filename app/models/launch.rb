class Launch < ApplicationRecord
  belongs_to :rocket, optional: true
  belongs_to :launchpad, optional: true
end