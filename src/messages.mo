
module {

    // Global Messages
    public let not_authorized:Text = "Not Authorized";
    public let not_owner:Text = "You are not owner";
    public let invalid_principal:Text = "Invalid Principal";
    public let success_operation:Text = "Success Operation";

    // Validation messages
    public let owner_is_required:Text = "The new owner is required";
    public let payment_method_is_required:Text = "The payment method is required";
    public let payment_method_invalid_value:Text = "The Payment method Invalid value";
    public let currency_is_required:Text = "The currency is required";
    public let currency_invalid_value:Text = "The Currency Invalid value";
    public let invoice_amount_must_be_greater_than_zero:Text = "The invoice amount must be greater than zero";
    public let sum_invoice_items_is_incorrect:Text = "The sum of the invoice items is incorrect";

    public let transaction_id_is_required:Text =  "The transaction id is required";
    public let invoice_number_is_required:Text =  "The invoice number is required";
    public let invoice_not_found:Text =  "Invoice not found";
    public let invoice_not_pending:Text =  "The invoice is not pending";
    public let invoice_not_paid:Text =  "The invoice is unpaid or not paid";

    public let unpaid_error_message  = "The invoice is still unpaid. Please complete the payment.";
    public let already_paid_error_message  = "The invoice has already been paid.";
    public let payment_failed_error_message = "The payment process failed, but the invoice has already been paid.";

    // Process Messages
    public let created_invoice_successfully:Text = "Invoice created successfully";
    public let created_invoice_failed:Text = "Invoice creation failed";

    public let confirmed_invoice_successfully:Text = "Invoice completed successfully";
    public let cancelled_invoice_successfully:Text = "Invoice cancelled successfully";
    public let confirmed_invoice_failed:Text = "Invoice confirmed failed";    

}