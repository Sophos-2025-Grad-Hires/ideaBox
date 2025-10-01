import { api, LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class Idbx_IdeaCard extends NavigationMixin(LightningElement) {
   @api idea;
   ideaPageURL;
   ownerPageURL;

   get CreatedDate() {
       return new Date(this.idea.CreatedDate).toLocaleDateString();
   }

   get statusClass() {
       const baseClass = 'status slds-text-heading_small slds-text-align_center';
       switch(this.idea.idbx_Status__c) {
           case 'Open':
               return `${baseClass} status-open`;
           case 'Approved':
               return `${baseClass} status-approved`;
           case 'Rejected':
               return `${baseClass} status-rejected`;
           case 'In Development':
               return `${baseClass} status-in-development`;
           case 'Delivered':
               return `${baseClass} status-delivered`;
           default:
               return baseClass;
       }
   }

   connectedCallback() {
        // Generate a URL to the record page
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.idea.Id,
                actionName: 'view',
            },
        }).then(url => {
            this.ideaPageURL = url;
        });

        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.idea.CreatedById,
                actionName: 'view',
            },
        }).then(url => {
            this.ownerPageURL = url;
        });
    }
}