# frozen_string_literal: true

class ApiController < ApplicationController
  rescue_from StandardError, with: :rescue_standard_error
  rescue_from ActiveRecord::RecordInvalid, with: :rescue_record_invalid

  private

  def rescue_standard_error(error)
    logger.error error
    logger.error error.backtrace.join("\n")

    respond_to { |format| format.json { render json: error, status: :internal_server_error } }
  end

  def rescue_record_invalid(invalid)
    errors = invalid.record.errors.full_messages
    logger.error errors

    respond_to { |format| format.json { render json: errors, status: :unprocessable_entity } }
  end
end
