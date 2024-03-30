import { LightningElement, track } from 'lwc';
import getOrderOfExecutionApex from '@salesforce/apex/OrderOfExecutionController.getOrderOfExecution';

export default class OrderOfExecutionExplorerView extends LightningElement {
	@track inputValue = '';

    handleInputChange(event) {
        this.inputValue = event.target.value;
    }

    handleSubmit() {
        // alert('Input value submitted: ' + this.inputValue);
		getOrderOfExecutionApex('a001m0000040sQ3AAI')
		.then(result => {
			console.log(result);
		});
    }
}