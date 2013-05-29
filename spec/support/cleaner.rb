module Cleaner
  def self.start_garbage_collection
    Element.all.each{ |elem| elem.delete } if Element.all.size > 0
    Category.all.each{ |cat| cat.delete } if Category.all.size > 0
    Ohm.flush
    User.delete_all
    Role.delete_all
  end
end
