import { LightningElement, track } from 'lwc';
import getOrderOfExecution from '@salesforce/apex/OrderOfExecutionController.getOrderOfExecution';

export default class OrderOfExecutionExplorerView extends LightningElement {
	@track inputValue = '';

    handleInputChange(event) {
        this.inputValue = event.target.value;
    }

    handleSubmit() {
        alert('Input value submitted: ' + this.inputValue);
		getOrderOfExecution(this.inputValue)
            .then(result => {
				console.log(result);
                this.data = result;
                this.error = undefined;
            })
            .catch(error => {
                this.error = error;
                this.data = undefined;
            })
            .finally(() => {
                this.isLoading = false;
            });
    }
}