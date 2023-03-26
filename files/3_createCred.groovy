import com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey
import jenkins.model.*
import com.cloudbees.plugins.credentials.CredentialsScope
import com.cloudbees.plugins.credentials.CredentialsProvider
import com.cloudbees.plugins.credentials.domains.Domain
import hudson.util.Secret

def credentialsId = "cred_1"
def username = "ec2-user"

def header = "-----BEGIN RSA PRIVATE KEY-----"
def footer = "-----END RSA PRIVATE KEY-----"

def privateKey = """MIIEpQIBAAKCAQEAwxIT9+OnV7GEij4QDbClYZCu1tQgh7+KozpHB2HEKCY4rh96 L/1CYW/xscgurSHvUBetlw1fUNNpeZU4Nu9TZYasMSWpoWlU9IA0m3Y11yJYfS9/ LkX3UFkv6B7f0KR8QDzrvELAcR6KqU6yQizq+VuMxYYJF+KFlHMw8C5sETEKqxbZ vMbDlq1Kfo2NVcJpSMTCQIIwGa42NvfMpIDFkv2i1a8eBBGIQn8e3zUntKPzuySF lumOfYJnm2OECbpLcjZt2mW84FRYhuCxIiUOyZ4oD264fbhuKuS+7w03/vMZ3KIA hEPge16UY/MoSlDKjbZk5pTDJbh+Wrk4eicQawIDAQABAoIBACEaxkzBU7rsI2Qa mDraiZZ/KUzH/yVKekqtLzSvgMyXf/L84I2YW1WR2+Ch6lnzcluTSSBjYpOi7Tl2 +21HPE30hvBoRdtgtswvnb3sV8LEz2OfVeQSd6ApIpov8yfDYlq8e/0dDu+jkUCe XF4ipVXgFYnH728gQC8rRVjdZ/WaowpaGhkKBPFTNNZFa4p/zEtcHzVDbX03Su8Z i5+F//snE/67sQd+BDB22Xu1KCwcWPZk2AzcFercw73dfej4VY0Sa48nAzPRZzis yJdT9OTfBQWjIfEdn8Di1NaRiwbN5bYHEVFa7iV9YpsXi1O5aEcuzIz05M5ZgfVo MmS2k8ECgYEA7VXRLWIYDEwuEXOJqgLWnVWq7VLr5gA4ZbmEuSwmGeym3YrOVPM5 TdIREe9VsWCI3cEtly6cyzIbh6qOX9cTPKi9X2HVNwNXcWAadJLs57JcodgWp7z7 voGOvv7LHrp5M9pctrkRVbyc4PyQj0ERg1k9ZFEWW5RJcgig+/nYhDECgYEA0mlc 9OECdC/ucHsmdunierepCIBU5xBIAZmoafHw5Mxuc8TgsuVRTq73pmeMgpc2c6+2 +oV7m8ZYZ+nOkEbyxe1tQc9H9ri+mAQEla4wLv1i5uuc8X1OUg+Q4n1wPCdoKcYh lItu84LIsiZhZCisDvuYRB9tVMHa8mHJ+0t7g1sCgYEAnkT0UYdw8gJ7VjfuPenW pOVULx91INRUx8GHuNSwM+mU/XhrUEtCk5rat1MbmkX9/6Ore34iIX8wzK/4cgFD WthMMSdUwHMCBSFJgyPXyEsxatxnf0SPvOM5BjVzzvIbkXC1E0UnQj2dgIvs+xsx Sp5gSl2owzmIIPuQH3jl4oECgYEArl6gqVL6/JxoJhD4jF1A0d/4FdJ8CcylT6Yu OjZFIucDta73Y2nE2scG9oEjoWl8t5xrr+sEx9A0nVDWXRxevoYHIB2ODrmFQWc7 AWwMBDT6TFH/iuUEDd9We0vmwgMKQGwwkfCHLwg4F+LUnPNTu0rnIbVFnpLURj+h 6j3gircCgYEAxvFyzb6SaZNh+fcy/aoZJjPgs6wJ94Vugoj9PBpvZTiDrkSyOcwO co4DAMZdnBGQzSViil1/DT6K/l0fjYV7LXo8m8/LhqwoGYf02HjSue5DvkdKT1UX wFuu5BXNEqZunN7injn+NMGJeuX/TE0f3RgBfA/ums/Ig9qJC0Jt9yo="""

def splitString = privateKey.split(' ')

def sublist = splitString.subList(4, splitString.size() - 4)
privateKey = sublist.join(' ')

privateKey = header + '\n' + privateKey.replaceAll(/\s+/, '\n') + '\n' + footer

println privateKey

def credential = new BasicSSHUserPrivateKey(
    CredentialsScope.GLOBAL,
    credentialsId,
    username,
    new BasicSSHUserPrivateKey.DirectEntryPrivateKeySource(privateKey),
    null,
    "My SSH credential description")

CredentialsProvider.lookupStores(Jenkins.getInstance()).each { store ->
    store.addCredentials(Domain.global(), credential)
}

println "SSH credential ${credentialsId} created successfully."
