#!/usr/bin/env cwl-runner

class: Workflow
id: somatic-variant-call-TNpair
label: somatic-variant-call-TNpair
cwlVersion: v1.1

$namespaces:
  edam: http://edamontology.org/

inputs:
  reference:
    type: File
    format: edam:format_1929
    secondaryFiles:
      - .fai
      - ^.dict
  tumor_cram:
    type: File
    format: edam:format_3462
    secondaryFiles:
      - .crai
  normal_cram:
    type: File
    format: edam:format_3462
    secondaryFiles:
      - .crai
  normal_name:
    doc: sample name of normal (read group (RG) sample (SM) field)
    type: string
  germline_resource:
    doc: e.g. af-only-gnomad.hg38.vcf.gz
    type: File
    format: edam:format_3016
    secondaryFiles:
      - .tbi
  panel_of_normals:
    type: File
    format: edam:format_3016
    secondaryFiles:
      - .tbi
  interval_list:
    type: File?
  variants_for_contamination:
    doc: e.g. small_exac_common_3.hg38.vcf.gz
    type: File
    format: edam:format_3016
    secondaryFiles:
      - .tbi
  Mutect2_java_options:
    type: string?
  Mutect2_native_pair_hmm_threads:
    type: int?
    inputBinding:
      position: 10
      prefix: --native-pair-hmm-threads
  Mutect2_extra_args:
    type: string?
  GetPileupSummaries_java_options:
    type: string?
  GetPileupSummaries_extra_args:
    type: string?
  outprefix:
    type: string

steps:
  Mutect2:
    label: Mutect2
    run: ../Tools/Mutect2.cwl
    in:
      java_options: Mutect2_java_options
      reference: reference
      tumor_cram: tumor_cram
      normal_cram: normal_cram
      normal_name: normal_name
      germline_resource: germline_resource
      interval_list: interval_list
      panel_of_normals: panel_of_normals
      native_pair_hmm_threads: Mutect2_native_pair_hmm_threads
      extra_args: Mutect2_extra_args
      outprefix: outprefix
    out: [vcf_gz, stats, f1r2_tar_gz, log]
  GetPileupSummaries_tumor:
    label: GetPileupSummaries
    run: ../Tools/GetPileupSummaries.cwl
    in:
      java_options: GetPileupSummaries_java_options
      reference: reference
      cram: tumor_cram
      is_tumor: true
      interval_list: interval_list
      variants_for_contamination: variants_for_contamination
      extra_args: GetPileupSummaries_extra_args
      outprefix: outprefix
outputs:
  Mutect2_log:
    type: File
    outputSource: Mutect2/log
