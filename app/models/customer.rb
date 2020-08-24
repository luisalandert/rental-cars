class Customer < ApplicationRecord
  def information
    "#{name} - #{cpf}"
  end
end
