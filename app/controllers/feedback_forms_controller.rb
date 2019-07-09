# frozen_string_literal: true

# Controller for Feedback forms
class FeedbackFormsController < ApplicationController
  def new; end

  def create
    return unless request.post?

    if validate
      FeedbackMailer.submit_feedback(params, request.remote_ip).deliver_now
      flash[:success] = t 'mylibrary.feedback_form.success'
    end
    respond_to do |format|
      format.json do
        render json: flash
      end
      format.html do
        redirect_to params[:url]
      end
    end
  end

  protected

  def url_regex
    %r{/.*href=.*|.*url=.*|.*http:\/\/.*|.*https:\/\/.*/i}
  end

  def validate
    errors = []
    errors << 'A message is required' if params[:message].blank?
    if params[:email_address].present?
      errors << 'You have filled in a field that makes you appear as a spammer.  Please follow the directions for the individual form fields.'
    end
    if params[:message]&.match(url_regex)
      errors << 'Your message appears to be spam, and has not been sent. Please try sending your message again without any links in the comments.'
    end
    if params[:user_agent] =~ url_regex ||
       params[:viewport] =~ url_regex
      errors << 'Your message appears to be spam, and has not been sent.'
    end
    flash[:danger] = errors.join('<br/>') unless errors.empty?
    flash[:danger].nil?
  end
end
