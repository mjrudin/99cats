class CatRentalRequest < ActiveRecord::Base
  attr_accessible :begin_date, :cat_id, :end_date, :status

  validate :cat_id, :begin_date, :end_date, :presence => true
  validate :end_date_after_start, :start_date_not_in_past, :no_rental_conflict

  belongs_to :cat

  def end_date_after_start
    if end_date < begin_date
      errors.add(:end_date, "Cannot return a cat before you have rented.")
    end
  end

  def start_date_not_in_past
    if begin_date < Date.today
      errors.add(:begin_date, "Cannot travel back in time.")
    end
  end

  def no_rental_conflict
    cat = CatRentalRequest.where(["((:begin_date BETWEEN begin_date AND end_date)
                                  OR (:end_date BETWEEN begin_date AND end_date))
                                  AND (cat_id = :cat_id)
                                  AND (id != :id)
                                  AND status = 'approved'",
                                  {begin_date: begin_date, end_date: end_date,
                                    cat_id: cat_id, id: id}])
    errors.add(:begin_date, "Rental conflict.") unless cat.empty?
  end

  def approve
    req = CatRentalRequest.where(["((begin_date BETWEEN :begin_date AND :end_date)
                                  OR (end_date BETWEEN :begin_date AND :end_date))
                                  AND (id != :id)
                                  AND (cat_id = :cat_id)
                                  AND status = 'undecided'",
                                  {begin_date: begin_date, end_date: end_date,
                                    cat_id: cat_id, id: id}])
    req.each do |r|
      r.update_attribute(:status, "denied")
    end
  end

end


