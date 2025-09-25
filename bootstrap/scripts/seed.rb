puts "Seeding sample doctors and patients..."
d1 = Doctor.find_or_create_by!(first_name: "Gregory", last_name: "House")
d2 = Doctor.find_or_create_by!(first_name: "Meredith", last_name: "Grey")
p1 = Patient.find_or_create_by!(first_name: "Ivan", last_name: "Ivanov", middle_name: "Ivanovich", birthday: Date.new(1990,1,1), gender: "male", height: 180, weight: 80)
p2 = Patient.find_or_create_by!(first_name: "Anna", last_name: "Petrova", birthday: Date.new(1995,5,5), gender: "female", height: 165, weight: 60)
p1.doctors << d1 unless p1.doctors.include?(d1)
p2.doctors << d2 unless p2.doctors.include?(d2)
puts "Done."
