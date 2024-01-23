#cloud-config

runcmd:
- <%=instance.cloudConfig.agentInstall%>
- <%=instance.cloudConfig.finalizeServer%>
