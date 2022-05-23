#!/usr/bin/env cwl-runner

class: CommandLineTool
id: mutect2
label: mutect2
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
  tumor_cram:
    type: File
    format: edam:format_3462
    secondaryFiles:
      - .crai
    inputBinding:
      position: 4
      prefix: -I
  normal_cram:
    type: File?
    format: edam:format_3462
    secondaryFiles:
      - .crai
    inputBinding:
      position: 5
      prefix: -I
  normal_name:
    type: string?
    inputBinding:
      position: 6
      prefix: --normal-sample
  germline_resource:
    type: File
    format: edam:format_3016
    secondaryFiles:
      - .tbi
    inputBinding:
      position: 7
      prefix: --germline-resource
  interval_list:
    type: File?
    inputBinding:
      position: 8
      prefix: -L
  panel_of_normals:
    type: File
    format: edam:format_3016
    secondaryFiles:
      - .tbi
    inputBinding:
      position: 9
      prefix: --panel-of-normals
  extra_args:
    type: string?
    inputBinding:
      position: 12
      shellQuote: false
  outprefix:
    type: string

outputs:
  vcf:
    type: File
    format: edam:format_3016
    outputBinding:
      glob: $(inputs.outprefix).somatic.vcf.gz
  f1r2:
    type: File
    outputBinding:
      glob: $(inputs.outprefix).somatic.f1r2.tar.gz
 log:
    type: stderr

arguments:
  - position: 2
    valueFrom: Mutect2
  - position: 10
    prefix: --f1r2-tar-gz
    valueFrom: $(inputs.outprefix).somatic.f1r2.tar.gz
  - position: 11
    prefix: -O
    valueFrom: $(inputs.outprefix).somatic.vcf.gz

stderr: $(inputs.outprefix).somatic.vcf.log
