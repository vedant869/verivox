public with sharing class ControllerGetLogo {
        public String imageURL{get;set;}
        public ControllerGetLogo() {
            List< document > documentList=[select name from document where Name='Verivox_Logo'];
            if(documentList.size()>0)
            {
              System.debug('found doc'+documentList);
              imageURL=URL.getOrgDomainURL().toExternalForm()+'/servlet/servlet.ImageServer?id='+documentList[0].id+'&oid='+UserInfo.getOrganizationId(); //Get image from Documents
    
            }
        }
}
