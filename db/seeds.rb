user1 = User.create(email: 'test@test.com', password: 'test@1234', employee_id: '18151', activated: true)
user2 = User.create(email: 'test1@test.com', password: 'test@1234', employee_id: '19023')
user3 = User.create(email: 'test2@test.com', password: 'test@1234', employee_id: '15511', activated: true)

user4 = User.create(email: 'maintainer1@test.com', password: 'test@1234', employee_id: '16093', activated: true, role: "3")
admin1 = User.create(email: 'admin@test.com', password: 'test@1234', employee_id: '18511', activated: true, role: "1")

candidate1 = Candidate.create(name: 'James Anderson', cv_url: 'https://d.novoresume.com/images/doc/minimalist-resume-template.png', cv_key: 'minimalist-resume-template.png', status: 'not interviewed', referred_by: 'test@test.com', stack: 'MEAN', experience_years: '1',user: user1)
candidate2 = Candidate.create(name: 'Babar Azam', cv_url: 'https://resume-example.com/wp-content/uploads/2021/03/budapest-half.png', cv_key: 'budapest-half.png', status: 'interviewed by 2', referred_by: 'test@test.com', stack: 'MEAN', experience_years: '2', user: user1)
candidate3 = Candidate.create(name: 'Stuart Broad', cv_url: 'https://cdn-images.zety.com/templates/zety/cascade-3-duo-blue-navy-21@3x.png', cv_key: 'cascade-3-duo-blue-navy-21@3x.png', status: 'interviewed by 3', referred_by: 'test2@test.com', stack: 'MERN', experience_years: '4', user: user3)

interview1 = Interview.create(scheduled_time: '08/10/2019 04:10AM', location: 'online', url: 'www.google.com', candidate: candidate1, users: [user1, user3])
interview2 = Interview.create(scheduled_time: '08/10/2019 05:10AM', location: 'online', url: 'www.google.com', candidate: candidate1, users: [user3])

feedback1 = Feedback.create(status: 'rejected', remarks: 'not enough skills', file_url: 'https://albantsh.co.uk/feedback-its-what-happens-in-the-classroom-that-counts/', file_key: 'feedback-its-what-happens-in-the-classroom-that-counts', user: user4, interview: interview1)