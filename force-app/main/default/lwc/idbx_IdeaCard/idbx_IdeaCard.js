import { api, LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class Idbx_IdeaCard extends NavigationMixin(LightningElement) {
   @api idea;
   ideaPageURL = 'https://google.com';

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
    }
}