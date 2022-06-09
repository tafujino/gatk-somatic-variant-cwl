#!/usr/bin/env cwl-runner

class: CommandLineTool
id: FilterMutectCalls
label: FilterMutectCalls
cwlVersion: v1.1

$namespaces:
  edam: http://edamontology.org/

hints:
  - class: DockerRequirement
    dockerPull: broadinstitute/gatk:4.2.6.1

requirements:
  ShellCommandRequirement: {}

baseCommand: [ gatk ]

inputs:
  java_options:
    type: string?
    inputBinding:
      position: 1
      prefix: --java-options
  reference:
    type: File
    format: edam:format_1929
    secondaryFiles:
      - .fai
      - ^.dict
    inputBinding:
      position: 3
      prefix: -R
  contamination_table:
    type: File
    inputBinding:
      position: 4
      prefix: --contamination-table
  tumor_segmentation:
    type: File
    inputBinding:
      position: 5
      prefix: --tumor-segmentation
  orientation-bias-artifact-priors:
    type: File
    inputBinding:
      position: 6
      prefix: --orientation-bias-artifact-priors
  stats:
    type: File
    inputBinding:
      position: 7
      prefix: --stats
  extra_args:
    type: string?
    inputBinding:
      position: 10
      shellQuote: false
  outprefix:
    type: string

outputs:
  vcf_gz:
    type: File
    outputBinding:
      glob: $(inputs.outprefix).somatic.filter.vcf.gz
  filtering_stats:
    type: File
    outputBinding:
      glob: $(inputs.outprefix).somatic.filter.stats
  log:
    type: stderr

arguments:
  - position: 2
    valueFrom: FilterMutectCalls
  - position: 8
    prefix: -O
    valueFrom: $(inputs.outprefix).somatic.filter.vcf.gz
  - position: 9
    prefix: --filtering-stats
    valueFrom: $(inputs.outprefix).somatic.filter.stats

stderr: $(inputs.outprefix).somatic.filter.log
