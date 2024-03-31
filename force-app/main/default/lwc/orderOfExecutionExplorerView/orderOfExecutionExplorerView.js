import { LightningElement, track } from 'lwc';
import getOrderOfExecution from '@salesforce/apex/OrderOfExecutionController.getOrderOfExecution';

export default class OrderOfExecutionExplorerView extends LightningElement {
	@track inputValue = '';
	//TODO: return Map of headers to List<String> of classes, etc. to be called from Apex
	headers = ['Validation Rules'];
	sections;
	showList = false;

    handleInputChange(event) {
        this.inputValue = event.target.value;
    }

    async handleSubmit() {
        // alert('Input value submitted: ' + this.inputValue);
		try {
			let result = await getOrderOfExecution({recordId: this.inputValue});
			let i = 1;
			result = result.map(element => {
				return {id: i++, name: element};
			});

			this.sections = [
				{
					id: 1,
					header: 'Validation Rules',
					items: result 
				}
			];
			console.log(result);
			this.showList = true;
		} catch (error) {
			console.error(error);
		}
    }
}