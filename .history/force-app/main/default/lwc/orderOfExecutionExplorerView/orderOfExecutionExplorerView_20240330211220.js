import { LightningElement, track } from 'lwc';
import getOrderOfExecutionApex from '@salesforce/apex/OrderOfExecutionController.getOrderOfExecution';

export default class OrderOfExecutionExplorerView extends LightningElement {
	@track inputValue = '';

    handleInputChange(event) {
        this.inputValue = event.target.value;
    }

    async handleSubmit() {
        // alert('Input value submitted: ' + this.inputValue);
		let result = await getOrderOfExecutionApex('a001m0000040sQ3AAI')
		console.log(result);
    }
}