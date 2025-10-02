import { wire, LightningElement } from 'lwc';
import selectAll from '@salesforce/apex/IdeaSelector.selectAll';

export default class Idbx_IdeasPage extends LightningElement {
    ideasUnfiltered;
    error;
    
    @wire(selectAll)
    wiredIdeas({ error, data }) {
        if (data) {
            this.ideasUnfiltered = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.ideasUnfiltered = undefined;
        }
    }

    get noIdeasAvailable() {
        return !this.ideasUnfiltered || this.ideasUnfiltered.length === 0;
    }

    get ideas() {
        if (this.queryTerm && this.queryTerm.trim() !== '') {
            const lowerCaseQuery = this.queryTerm.toLowerCase();
            return this.ideasUnfiltered.filter(idea =>
                idea.Name.toLowerCase().includes(lowerCaseQuery)
            );
        }
        return this.ideasUnfiltered;
    }

    // Search functionality
    queryTerm;

    handleSearch(event) {
        const isEnterKey = event.keyCode === 13;

        if (isEnterKey) {
            this.queryTerm = event.target.value;
        }
    }

    handleClearSearchBar(event) {
        if (event.target.value === '') {
            this.queryTerm = '';
        }
    }
}