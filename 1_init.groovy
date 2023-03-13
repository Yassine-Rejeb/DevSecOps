import jenkins.model.Jenkins
import jenkins.model.*
import hudson.security.*
import org.jenkinsci.plugins.*
import jenkins.security.s2m.AdminWhitelistRule
import jenkins.install.*

def instance = Jenkins.getInstance()

// Create a new security realm with the admin user
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount("M0D4S", "MedYassPass")

// Set the security realm and authorization strategy for the instance
instance.setSecurityRealm(hudsonRealm)
def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
strategy.setAllowAnonymousRead(false)
instance.setAuthorizationStrategy(strategy)

// Install the recommended plugins
//def pluginManager = Jenkins.instance.pluginManager
//def pluginList = ['git', 'workflow-aggregator', 'pipeline-stage-view', 'ws-cleanup', 'credentials-binding']
//pluginList.each { pluginName ->
//  if (!pluginManager.getPlugin(pluginName)) {
//    pluginManager.installPlugin(pluginName)
//  }
//}

// Set the Jenkins URL
def jenkinsUrl = "http://your-jenkins-url.com"
System.setProperty("JenkinsUrl", jenkinsUrl)

//def jenkinsLocationConfiguration = JenkinsLocationConfiguration.get()
//jenkinsLocationConfiguration.setUrl("http://localhost:8080/")
//jenkinsLocationConfiguration.save()

// Install suggested plugins
def pluginManager = Jenkins.instance.pluginManager
def pluginList = pluginManager.getSuggestedPlugins()

def pluginShortNames = pluginList.collect { it.shortName }

pluginManager.installPlugins(pluginShortNames)

// Save the instance configuration
instance.save()

// Enable the Script Security sandbox
//def scriptApproval = Jenkins.instance.getExtensionList(jenkins.security.s2m.AdminWhitelistRule.class).get(0).getScriptApproval()
//scriptApproval.approveSignature("method java.lang.ProcessBuilder start")
//scriptApproval.save()

