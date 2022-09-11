# user profiles
user1 = User.create(email: 'test@test.com', password: 'test@1234', employee_id: '18151', activated: true)
user2 = User.create(email: 'test1@test.com', password: 'test@1234', employee_id: '19023')
user3 = User.create(email: 'test2@test.com', password: 'test@1234', employee_id: '15511', activated: true)

user4 = User.create(email: 'maintainer1@test.com', password: 'test@1234', employee_id: '16093', activated: true, role: "3")
admin1 = User.create(email: 'admin@test.com', password: 'test@1234', employee_id: '18511', activated: true, role: "1")

# candidates
candidate1 = Candidate.create(name: 'James Anderson', cv_url: 'https://d.novoresume.com/images/doc/minimalist-resume-template.png', cv_key: 'minimalist-resume-template.png', stack: 'MEAN', experience_years: '1',user: user1)
candidate2 = Candidate.create(name: 'Babar Azam', cv_url: 'https://resume-example.com/wp-content/uploads/2021/03/budapest-half.png', cv_key: 'budapest-half.png', stack: 'MEAN', experience_years: '2', user: user1)
candidate3 = Candidate.create(name: 'Stuart Broad', cv_url: 'https://cdn-images.zety.com/templates/zety/cascade-3-duo-blue-navy-21@3x.png', cv_key: 'cascade-3-duo-blue-navy-21@3x.png', stack: 'MERN', experience_years: '4', user: user3)

# interviews
interview1 = Interview.create(scheduled_time: '08/10/2019 04:10AM', location: 'online', url: 'www.google.com', candidate: candidate1, users: [user1, user3])
interview2 = Interview.create(scheduled_time: '08/10/2019 05:10AM', location: 'online', url: 'www.google.com', candidate: candidate1, users: [user3])

# feedbacks
feedback1 = Feedback.create(status: 'rejected', remarks: 'not enough skills', file_url: 'https://albantsh.co.uk/feedback-its-what-happens-in-the-classroom-that-counts/', file_key: 'feedback-its', user: user4, interview: interview2)
feedback2 = Feedback.create(status: 'recommended', remarks: 'good angular skills', file_url: 'https://albantsh.co.uk/feedback-its-what-happens-in-the-classroom-that-counts/', file_key: 'feedback-its', user: user1, interview: interview1)

# common data
question1 = Question.create(course: 'angular', description: 'Explain end-end flow of angular app working', answer: 'runs from app module and goes to components', user: user1)
question2 = Question.create(course: 'ruby', description: 'How to perform testing in ruby', answer: 'use rspec and minitest gems', user: user3)

# lovs
lov_roles1 = Lov.create(category: 'roles', name: 'admin', value: '1')
lov_roles2 = Lov.create(category: 'roles', name: 'platform', value: '2')
lov_roles3 = Lov.create(category: 'roles', name: 'maintainer', value: '3')

lov_stack1 = Lov.create(category: 'stack', name: 'MEAN', value: 'MEAN')
lov_stack2 = Lov.create(category: 'stack', name: 'MERN', value: 'MERN')
lov_stack3 = Lov.create(category: 'stack', name: 'Ruby on Rails', value: 'Ruby on Rails')
lov_stack4 = Lov.create(category: 'stack', name: '.Net', value: '.Net')
lov_stack5 = Lov.create(category: 'stack', name: 'Android', value: 'Android')
lov_stack6 = Lov.create(category: 'stack', name: 'PHP', value: 'PHP')
lov_stack7 = Lov.create(category: 'stack', name: 'Drupal', value: 'Drupal')

lov_feedback_status1 = Lov.create(category: 'feedback_status', name: 'recommended', value: 'recommended')
lov_feedback_status2 = Lov.create(category: 'feedback_status', name: 'rejected', value: 'rejected')
lov_feedback_status3 = Lov.create(category: 'feedback_status', name: 'onhold', value: 'onhold')
lov_feedback_status4 = Lov.create(category: 'feedback_status', name: 'approved', value: 'approved')

lov_course1 = Lov.create(category: 'course', name: 'angular', value: 'angular')
lov_course2 = Lov.create(category: 'course', name: 'react', value: 'react')
lov_course3 = Lov.create(category: 'course', name: 'node', value: 'node')
lov_course4 = Lov.create(category: 'course', name: 'Ruby on Rails', value: 'Ruby on Rails')
lov_course5 = Lov.create(category: 'course', name: '.Net', value: '.Net')
lov_course6 = Lov.create(category: 'course', name: 'javascript', value: 'javascript')