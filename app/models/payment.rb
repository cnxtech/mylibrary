# frozen_string_literal: true

# Model for a Payment on the Fine page
class Payment
  attr_reader :record

  def initialize(record)
    @record = record
  end

  def key
    record['billNumber']
  end

  def bill_description
    record['billReasonDescription']
  end

  def bill_amount
    record['amount']
  end

  def bill_date
    Time.strptime(record['dateBilled'], '%Y-%m-%d')
  end

  def item_title
    fee_item_info && fee_item_info['title'] || 'No item associated with this payment'
  end

  def item_library
    fee_item_info && fee_item_info['itemLibraryID']
  end

  def payment_amount
    fee_pay_info && fee_pay_info['paymentAmount']
  end

  def payment_date
    fee_pay_info && Time.strptime(fee_pay_info['paymentDate'], '%Y-%m-%d')
  end

  def sort_key
    return Time.zone.parse(fee_pay_info['paymentDate']) if fee_pay_info && fee_pay_info['paymentDate']

    Request::END_OF_DAYS
  end

  def resolution
    return fee_pay_info['paymentTypeDescription'] if fee_pay_info['paymentTypeDescription']
    return 'Paid' if payment_amount

    'Unknown'
  end

  def paid_fee?
    %w[CASH CHECK CREDITCARD].include? fee_pay_info['paymentTypeID']
  end

  def to_partial_path
    'fines/payment'
  end

  private

  def fee_pay_info
    Array.wrap(record['feePaymentInfo']).first
  end

  def fee_item_info
    record['feeItemInfo']
  end
end
