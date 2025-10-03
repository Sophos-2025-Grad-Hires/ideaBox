import { api, LightningElement } from 'lwc';
import getScore from '@salesforce/apex/idbx_VoteObjectSelector.getScore';
import vote from '@salesforce/apex/idbx_VoteObjectSelector.vote';
import getCurrentButtonStatus from '@salesforce/apex/idbx_VoteObjectSelector.getCurrentButtonStatus';
import headerImage from '@salesforce/resourceUrl/idbx_VotingWidgetHeader';

const VOTE_TYPES = {
    UPVOTE: 'Upvote',
    DOWNVOTE: 'Downvote',
    NEUTRAL: 'Neutral'
};

const VARIANTS = {
    SUCCESS: 'success',
    DESTRUCTIVE: 'destructive',
    NEUTRAL: 'neutral'
};

export default class idbx_VotingWidget extends LightningElement {
    @api recordId;
    score;
    error;
    upvoteVariant = VARIANTS.NEUTRAL;
    downvoteVariant = VARIANTS.NEUTRAL;
    headerImage = headerImage;

    async connectedCallback() {
        if (!this.recordId) return;

        try {
            this.score = await getScore({ recordId: this.recordId });
        } catch (err) {
            this.error = err;
        }

        try {
            const status = await getCurrentButtonStatus({ recordId: this.recordId });
            this.setButtonVariants(status);
        } catch (err) {
            this.error = err;
        }
    }

    setButtonVariants(status) {
        switch (status) {
            case VOTE_TYPES.UPVOTE:
                this.upvoteVariant = VARIANTS.SUCCESS;
                this.downvoteVariant = VARIANTS.NEUTRAL;
                break;
            case VOTE_TYPES.DOWNVOTE:
                this.upvoteVariant = VARIANTS.NEUTRAL;
                this.downvoteVariant = VARIANTS.DESTRUCTIVE;
                break;
            default:
                this.upvoteVariant = VARIANTS.NEUTRAL;
                this.downvoteVariant = VARIANTS.NEUTRAL;
        }
    }

    handleUpvote() {
        if (this.upvoteVariant === VARIANTS.SUCCESS) {
            this.updateVote(VOTE_TYPES.NEUTRAL);
            this.score -= 10;
            this.upvoteVariant = VARIANTS.NEUTRAL;
        } else {
            this.updateVote(VOTE_TYPES.UPVOTE);
            this.score += this.downvoteVariant === VARIANTS.DESTRUCTIVE ? 20 : 10;
            this.upvoteVariant = VARIANTS.SUCCESS;
            this.downvoteVariant = VARIANTS.NEUTRAL;
        }
    }

    handleDownvote() {
        if (this.downvoteVariant === VARIANTS.DESTRUCTIVE) {
            this.updateVote(VOTE_TYPES.NEUTRAL);
            this.score += 10;
            this.downvoteVariant = VARIANTS.NEUTRAL;
        } else {
            this.updateVote(VOTE_TYPES.DOWNVOTE);
            this.score -= this.upvoteVariant === VARIANTS.SUCCESS ? 20 : 10;
            this.downvoteVariant = VARIANTS.DESTRUCTIVE;
            this.upvoteVariant = VARIANTS.NEUTRAL;
        }
    }

    async updateVote(voteType) {
        try {
            await vote({ recordId: this.recordId, voteType });
        } catch (err) {
            this.error = err;
        }
    }
}