import { LightningElement, track } from 'lwc';
import getOrderOfExecution from '@salesforce/apex/OrderOfExecutionController.getOrderOfExecution';

export default class OrderOfExecutionExplorerView extends LightningElement {
	@track inputValue = '';

    handleInputChange(event) {
        this.inputValue = event.target.value;
    }

    async handleSubmit() {
        // alert('Input value submitted: ' + this.inputValue);
		try {
			let result = await getOrderOfExecution({recordId: this.inputValue});
			console.log(result);
		} catch (error) {
			console.error(error);
		}
    }
}