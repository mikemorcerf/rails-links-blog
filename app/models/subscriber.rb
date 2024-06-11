class Subscriber < ApplicationRecord
  validades :email, uniquiness: true
  validades :email, presence: true
end
