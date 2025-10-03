import { wire, LightningElement } from 'lwc';
import selectAll from '@salesforce/apex/IdeaSelector.selectAll';

export default class Idbx_IdeasPage extends LightningElement {
    _ideas;
    error;
    
    @wire(selectAll)
    wiredIdeas({ error, data }) {
        if (data) {
            this._ideas = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this._ideas = undefined;
        }
    }

    get noIdeasAvailable() {
        return !this._ideas || this._ideas.length === 0;
    }

    get ideas() {
        let transformedIdeas = this._ideas ? JSON.parse(JSON.stringify(this._ideas)) : [];

        // Search filtering
        if (this.queryTerm && this.queryTerm.trim() !== '') {
            const lowerCaseQuery = this.queryTerm.toLowerCase();
            transformedIdeas = transformedIdeas.filter(idea =>
                idea.Name.toLowerCase().includes(lowerCaseQuery)
            );
        }

        // Date sorting
        transformedIdeas.sort((a, b) => {
            const dateA = new Date(a.CreatedDate);
            const dateB = new Date(b.CreatedDate);
            return this.isDescending ? dateB - dateA : dateA - dateB;
        });

        return transformedIdeas;
    }

    // Search functionality
    queryTerm;

    handleSearch(event) {
        const isEnterKey = event.key === 'Enter';

        if (isEnterKey) {
            this.queryTerm = event.target.value;
        }
    }

    handleSearchChange(event) {
        if (event.target.value === '') {
            this.queryTerm = '';
        }
    }

    // Date Button functionality
    isDescending = true; 

    get buttonIcon() {
        return this.isDescending ? 'utility:chevrondown' : 'utility:chevronup';
    }

    get ariaLabel() {
        return this.isDescending 
            ? 'Sort ideas by date descending' 
            : 'Sort ideas by date ascending';
    }

    handleDateButtonClick() {
        this.isDescending = !this.isDescending;
    }
}