if Rails.env.test?
  Vlan.create!({name: "default", description: "Default Vlan.", vid: 1})

  %w[sebastien@sdeu.fr vincent@fricouv.eu rigonkmalk@gmail.com].each do |email|
    r = Random.urandom(128)
    User.create!({ email: email, password: r, password_confirmation: r })
  end
end
