import { LightningElement, track } from 'lwc';

export default class OrderOfExecutionExplorerView extends LightningElement {
	@track inputValue = '';

    handleInputChange(event) {
        this.inputValue = event.target.value;
    }

    handleSubmit() {
        // Handle submission logic here, e.g., send the input value to a server or perform some action
        alert('Input value submitted: ' + this.inputValue);
    }
}