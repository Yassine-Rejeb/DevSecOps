import jenkins.model.*
import hudson.security.*

// Define a list of users to create
def users = [
  [username: 'chxmxii', password: 'chxmxii', fullName: 'Mouhib Chamsi', email: 'chxmxii@mail.me'],
  [username: 'Iheb', password: 'Iheb', fullName: 'Iheb Mastouri', email: 'iheb@mail.me'],
  [username: 'Ahmed', password: 'Ahmed', fullName: 'Ahmed Brahim', email: 'ahmed@mail.me'],
  [username: 'Amine', password: 'Amine', fullName: 'Amine Klibi', email: 'amin@mail.me']
]

// Loop through the list of users and create them
def instance = Jenkins.getInstance()
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
for (user in users) {
  hudsonRealm.createAccount(user['username'], user['password'])
  def u = instance.getUser(user['username'])
  u.setFullName(user['fullName'])
  u.addProperty(new hudson.tasks.Mailer.UserProperty(user['email']))
  u.save()
}

// Optional: Add the users to a specific Jenkins group
def group = instance.getAuthorizationStrategy().getOrCreateGroup('project-group')
for (user in users) {
  group.add(instance.getUser(user['username']))
}
group.save()
