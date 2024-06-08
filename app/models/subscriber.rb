class Subscriber < ApplicationRecord
  validades :email, uniquiness: true
  validades :email, :first_name, :last_name, presence: true
end
