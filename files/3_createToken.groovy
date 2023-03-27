import hudson.model.*
import jenkins.model.*
import jenkins.security.*
import jenkins.security.apitoken.*

    // script parameters
def userName = 'm0d4s'
def tokenName = 'token'

def user = User.get(userName, false)
def apiTokenProperty = user.getProperty(ApiTokenProperty.class)
def result = apiTokenProperty.tokenStore.generateNewToken(tokenName)
user.save()

def file = new File("/tmp/m0d4s")
file.write("${result.plainValue}")

println "result: ${result.plainValue}"
