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
  mutect2_java_options:
    type: string?
  mutect2_native_pair_hmm_threads:
    type: int?
    inputBinding:
      position: 10
      prefix: --native-pair-hmm-threads
  mutect2_extra_args:
    type: string?
    inputBinding:
      position: 13
      shellQuote: false
  outprefix:
    type: string

steps:
  mutect2:
    label: Mutect2
    run: ../Tools/Mutect2.cwl
    in:
      java_options: mutect2_java_options
      reference: reference
      tumor_cram: tumor_cram
      normal_cram: normal_cram
      normal_name: normal_name
      germline_resource: germline_resource
      interval_list: interval_list
      panel_of_normals: panel_of_normals
      native_pair_hmm_threads: mutect2_native_pair_hmm_threads
      extra_args: mutect2_extra_args
      outprefix: outprefix
    out: [vcf_gz, stats, f1r2_tar_gz, log]

outputs:
  mutect2_log:
    type: File
    outputSource: mutect2/log
