class AgeValidator < ActiveModel::EachValidator
    def validate_each(record,attribute,value)
        if value != nil
            if(Date.today.year - value.year)<=18
                # record.errors.add(:date_of_birth," must be greater than 18.")
                record.errors.add(:dob, "must be greater than 18..")
            end
        end
    end
end