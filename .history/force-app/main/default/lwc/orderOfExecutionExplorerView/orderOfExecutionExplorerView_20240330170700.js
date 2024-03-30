import { LightningElement, track } from 'lwc';

export default class OrderOfExecutionExplorerView extends LightningElement {
	@track inputValue = '';

    handleInputChange(event) {
        this.inputValue = event.target.value;
    }

    handleSubmit() {
        alert('Input value submitted: ' + this.inputValue);
    }
}