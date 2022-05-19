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

baseCommand: [ gatk ]

inputs:
  reference:
    type: File
    format: edam:format_1929
    secondaryFiles:
      - .fai
      - ^.dict
  java_options:
    type: string?
    inputBinding:
      position: 1
      prefix: --java-options
  tumor_cram:
    type: File
    format: edam:format_3462
    secondaryFiles:
      - .crai
    inputBinding:
      prefix: -I
      position: 3
  normal_cram:
    type: File?
    format: edam:format_3462
    secondaryFiles:
      - .crai
    inputBinding:
      prefix: -I
      position: 4
  normal_name:
    type: string?
    inputBinding:
      prefix: --normal-sample
      position: 5
  germline_resource:
    type: File
    format: edam:format_3016
    secondaryFiles:
      - .tbi
    inputBinding:
      prefix: --germline-resource
      position: 6
  interval_list:
    type: File?
    inputBinding:
      prefix: --intervals
      position: 7
  panel_of_normals:
    type: File
    format: edam:format_3016
    inputBinding:
      prefix: --panel-of-normals
      position: 8
  extra_args:
    type: string
    inputBinding:
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

arguments:
  - position: 2
    valueFrom: Mutect2
  - position: 9
    prefix: --f1r2-tar-gz
    valueFrom: $(inputs.outprefix).somatic.f1r2.tar.gz
  - position: 10
    prefix: -O
    valueFrom: $(inputs.outprefix).somatic.vcf.gz
