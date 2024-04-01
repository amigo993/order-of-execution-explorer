import { LightningElement, track } from 'lwc';
import getOrderOfExecution from '@salesforce/apex/OrderOfExecutionController.getOrderOfExecution';

export default class OrderOfExecutionExplorerView extends LightningElement {
	@track inputValue = 'a001m0000040sQ3AAI';
	sections = [];
	showList = false;

    handleInputChange(event) {
        this.inputValue = event.target.value;
    }

    async handleSubmit() {
		try {
			let result = await getOrderOfExecution({recordId: this.inputValue});
			console.log(result);

			let headers = Object.keys(result);

			for (let index = 0; index < headers.length; index++) {
				const header = headers[index];
				const sectionItems = result[header];
				let id = 1;
				this.sections.push({
					id: index,
					header: header,
					items: sectionItems.map(sectionItem => {return {id: id++, name: sectionItem};})
				});
			}
			this.showList = true;
		} catch (error) {
			console.error(error);
		}
    }
}