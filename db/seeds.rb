user1 = User.create(email: 'test@test.com', password: 'test@1234', activated: true)
user2 = User.create(email: 'test1@test.com', password: 'test@1234')
admin1 = User.create(email: 'admin@test.com', password: 'test@1234', activated: true, role: "1")