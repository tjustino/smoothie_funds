# frozen_string_literal: true

# Implement an ActiveRecord model as an abstract class
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.to_xlsx(attributes, object)
    headers = []
    data    = []
    max_row = count
    max_col = attributes.size - 1

    table_name = I18n.transliterate(I18n.t("#{object}.new.#{object}"))

    attributes.each do |attribute|
      header_name = I18n.exists?("#{object}.form.#{attribute}") ? I18n.t("#{object}.form.#{attribute}") : attribute
      headers << { header: header_name }
    end

    find_each do |account|
      data << attributes.map { |attr| account.send(attr) }
    end

    io        = StringIO.new
    workbook  = WriteXLSX.new(io)
    worksheet = workbook.add_worksheet("SmoothieData")
    worksheet.add_table(0, 0, max_row, max_col, { name: table_name, columns: headers, data: data })
    workbook.close

    io.string
  end
end
