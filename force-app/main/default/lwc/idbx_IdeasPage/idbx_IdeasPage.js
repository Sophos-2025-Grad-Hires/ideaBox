import { wire, LightningElement } from 'lwc';
import selectAll from '@salesforce/apex/IdeaSelector.selectAll';
import { NavigationMixin } from 'lightning/navigation';

export default class Idbx_IdeasPage extends LightningElement {
    ideas;
    error;
    
    @wire(selectAll)
    wiredIdeas({ error, data }) {
        if (data) {
            this.ideas = data;
            this.error = undefined;
            console.log(data);
        } else if (error) {
            this.error = error;
            this.ideas = undefined;
        }
    }
}