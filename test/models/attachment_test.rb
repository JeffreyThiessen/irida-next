# frozen_string_literal: true

require 'test_helper'

class AttachmentTest < ActiveSupport::TestCase
  def setup
    @attachment1 = attachments(:attachment1)
    @sample = samples(:sample1)
  end

  test 'valid attachment' do
    assert @attachment1.valid?
  end

  test 'invalid when no file attached' do
    invalid_attachment = @sample.attachments.build
    assert_not invalid_attachment.valid?
    assert invalid_attachment.errors.added?(:file, :blank)
  end

  test 'invalid when file checksum matches another Attachment associated with the Attachable' do
    new_attachment = @sample.attachments.build
    new_attachment.file.attach(io: Rails.root.join('test/fixtures/files/test_file.fastq').open,
                               filename: 'test_file.fastq')
    assert_not new_attachment.valid?
    assert new_attachment.errors.added?(:file, :checksum_uniqueness)
  end

  test 'metadata format fastq file types' do
    new_fastq_attachment_ext_fastq = @sample.attachments.build
    new_fastq_attachment_ext_fastq.file.attach(io: Rails.root.join('test/fixtures/files/test_file_1.fastq').open,
                                               filename: 'test_file_1.fastq')
    new_fastq_attachment_ext_fastq.save
    assert_equal new_fastq_attachment_ext_fastq.metadata['format'], 'fastq'

    new_fastq_attachment_ext_fastq_gz = @sample.attachments.build
    new_fastq_attachment_ext_fastq_gz.file.attach(io: Rails.root.join('test/fixtures/files/test_file_2.fastq.gz').open,
                                                  filename: 'test_file_2.fastq.gz')
    new_fastq_attachment_ext_fastq_gz.save
    assert_equal new_fastq_attachment_ext_fastq_gz.metadata['format'], 'fastq'

    new_fastq_attachment_ext_fq = @sample.attachments.build
    new_fastq_attachment_ext_fq.file.attach(io: Rails.root.join('test/fixtures/files/test_file_3.fq').open,
                                            filename: 'test_file_3.fq')
    new_fastq_attachment_ext_fq.save
    assert_equal new_fastq_attachment_ext_fq.metadata['format'], 'fastq'

    new_fastq_attachment_ext_fq_gz = @sample.attachments.build
    new_fastq_attachment_ext_fq_gz.file.attach(io: Rails.root.join('test/fixtures/files/test_file_4.fq.gz').open,
                                               filename: 'test_file_4.fq.gz')
    new_fastq_attachment_ext_fq_gz.save
    assert_equal new_fastq_attachment_ext_fq_gz.metadata['format'], 'fastq'
  end

  test 'metadata format fasta file types' do
    new_fasta_attachment_ext_fasta = @sample.attachments.build
    new_fasta_attachment_ext_fasta.file.attach(io: Rails.root.join('test/fixtures/files/test_file_5.fasta').open,
                                               filename: 'test_file_5.fasta')
    new_fasta_attachment_ext_fasta.save
    assert_equal new_fasta_attachment_ext_fasta.metadata['format'], 'fasta'

    new_fasta_attachment_ext_fasta_gz = @sample.attachments.build
    new_fasta_attachment_ext_fasta_gz.file.attach(io: Rails.root.join('test/fixtures/files/test_file_6.fasta.gz').open,
                                                  filename: 'test_file_6.fasta.gz')
    new_fasta_attachment_ext_fasta_gz.save
    assert_equal new_fasta_attachment_ext_fasta_gz.metadata['format'], 'fasta'

    new_fasta_attachment_ext_fa = @sample.attachments.build
    new_fasta_attachment_ext_fa.file.attach(io: Rails.root.join('test/fixtures/files/test_file_7.fa').open,
                                            filename: 'test_file_7.fa')
    new_fasta_attachment_ext_fa.save
    assert_equal new_fasta_attachment_ext_fa.metadata['format'], 'fasta'

    new_fasta_attachment_ext_fa_gz = @sample.attachments.build
    new_fasta_attachment_ext_fa_gz.file.attach(io: Rails.root.join('test/fixtures/files/test_file_8.fa.gz').open,
                                               filename: 'test_file_8.fa.gz')
    new_fasta_attachment_ext_fa_gz.save
    assert_equal new_fasta_attachment_ext_fa_gz.metadata['format'], 'fasta'

    new_fasta_attachment_ext_fna = @sample.attachments.build
    new_fasta_attachment_ext_fna.file.attach(io: Rails.root.join('test/fixtures/files/test_file_9.fna').open,
                                             filename: 'test_file_9.fna')
    new_fasta_attachment_ext_fna.save
    assert_equal new_fasta_attachment_ext_fna.metadata['format'], 'fasta'

    new_fasta_attachment_ext_fna_gz = @sample.attachments.build
    new_fasta_attachment_ext_fna_gz.file.attach(io: Rails.root.join('test/fixtures/files/test_file_10.fna.gz').open,
                                                filename: 'test_file_10.fna.gz')
    new_fasta_attachment_ext_fna_gz.save
    assert_equal new_fasta_attachment_ext_fna_gz.metadata['format'], 'fasta'
  end

  test 'metadata format unknown file types' do
    new_unknown_attachment_ext_docx = @sample.attachments.build
    new_unknown_attachment_ext_docx.file.attach(io: Rails.root.join('test/fixtures/files/test_file_11.docx').open,
                                                filename: 'test_file_11.docx')
    new_unknown_attachment_ext_docx.save
    assert_equal new_unknown_attachment_ext_docx.metadata['format'], 'unknown'

    new_unknown_attachment_ext_pdf = @sample.attachments.build
    new_unknown_attachment_ext_pdf.file.attach(io: Rails.root.join('test/fixtures/files/test_file_12.pdf').open,
                                               filename: 'test_file_12.pdf')
    new_unknown_attachment_ext_pdf.save
    assert_equal new_unknown_attachment_ext_pdf.metadata['format'], 'unknown'

    new_unknown_attachment_ext_rtf = @sample.attachments.build
    new_unknown_attachment_ext_rtf.file.attach(io: Rails.root.join('test/fixtures/files/test_file_13.rtf').open,
                                               filename: 'test_file_13.rtf')
    new_unknown_attachment_ext_rtf.save
    assert_equal new_unknown_attachment_ext_rtf.metadata['format'], 'unknown'

    new_unknown_attachment_ext_txt = @sample.attachments.build
    new_unknown_attachment_ext_txt.file.attach(io: Rails.root.join('test/fixtures/files/test_file_14.txt').open,
                                               filename: 'test_file_14.txt')
    new_unknown_attachment_ext_txt.save
    assert_equal new_unknown_attachment_ext_txt.metadata['format'], 'unknown'
  end

  test '#destroy does not destroy the ActiveStorage::Attachment' do
    assert_no_difference('ActiveStorage::Attachment.count') do
      @attachment1.destroy
    end
  end

  test '#destroy is a soft deletion and sets deleted_at' do
    assert_nil @attachment1.deleted_at
    @attachment1.destroy
    assert_not_nil @attachment1.deleted_at
  end
end
