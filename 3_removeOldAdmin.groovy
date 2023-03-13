import jenkins.model.*
import hudson.security.*

def username = "admin"

// Get the Jenkins instance
def instance = Jenkins.getInstance()

// Get the security realm
def securityRealm = instance.getSecurityRealm()

// Get the list of users
def users = securityRealm.getSecurityComponents().userDetailsManager.getUsers()

// Find the user to remove
def userToRemove = users.find { user -> user.username == username }

// Remove the user
if (userToRemove != null) {
    securityRealm.getSecurityComponents().userDetailsManager.deleteUser(userToRemove.username)
    println("User ${username} has been successfully removed.")
} else {
    println("User ${username} not found.")
}
