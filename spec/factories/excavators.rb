FactoryBot.define do
  factory :excavator do
    company_name { "John Doe CONSTRUCTION" }
    address { "555 Some RD, SOME PARK, ZZ, 55555" }
    crew_onsite { true }

    ticket
  end
end
