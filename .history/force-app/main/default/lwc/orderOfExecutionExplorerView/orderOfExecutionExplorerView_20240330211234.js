import { LightningElement, track } from 'lwc';
import getOrderOfExecution from '@salesforce/apex/OrderOfExecutionController.getOrderOfExecution';

export default class OrderOfExecutionExplorerView extends LightningElement {
	@track inputValue = '';

    handleInputChange(event) {
        this.inputValue = event.target.value;
    }

    async handleSubmit() {
        // alert('Input value submitted: ' + this.inputValue);
		let result = await getOrderOfExecution('a001m0000040sQ3AAI')
		console.log(result);
    }
}