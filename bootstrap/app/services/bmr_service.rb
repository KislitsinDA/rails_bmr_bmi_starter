class BmrService
  # Expect patient.height in cm, weight in kg, gender 'male'/'female'
  def self.calculate(patient, formula)
    height = patient.height.to_f
    weight = patient.weight.to_f
    age = ((Date.today - patient.birthday).to_i / 365.25).floor
    raise ArgumentError, "Missing anthropometrics" if height <= 0 || weight <= 0 || age <= 0

    case formula
    when 'mifflin'
      base = 10 * weight + 6.25 * height - 5 * age
      patient.gender == 'male' ? (base + 5).round : (base - 161).round
    when 'harris'
      if patient.gender == 'male'
        (66.47 + 13.75 * weight + 5.003 * height - 6.755 * age).round
      else
        (655.1 + 9.563 * weight + 1.850 * height - 4.676 * age).round
      end
    else
      raise ArgumentError, "unknown formula"
    end
  end
end
