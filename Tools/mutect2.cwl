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
    doc: reference FASTA
  java_options:
    type: string?
    inputBinding:
      position: 1
      prefix: --java-options
  normal_bams:
    type:
      type: array
      items: File
      inputBinding:
        prefix: -I
    inputBinding:
      position: 2
  tumor_bams:
    type:
      type: array
      items: File
      inputBinding:
        prefix: -I
    inputBinding:
      position: 3
  normal_names:
    type:
      type: array
      items: string
      inputBinding:
        prefix: --normal-sample
    inputBinding:
      position: 4
  germline_resource:
    type: File
    format: edam:format_3016
    inputBinding:
      prefix: --germline-resource
      position: 5
  panel_of_normals:
    type: File
    format: edam:format_3016
    inputBinding:
      prefix: --panel-of-normals
      position: 6
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
      glob: $(inputs.outprefix).vcf.gz
  f1r2:
    type: File
    outputBinding:
      glob: $(inputs.outprefix).f1r2.tar.gz

arguments:
  - position: 2
    valueFrom: Mutect2
  - position: 7
    prefix: --f1r2-tar-gz
    valueFrom: $(inputs.outprefix).f1r2.tar.gz
  - position: 8
    prefix: -O
    valueFrom: $(inputs.outprefix).vcf.gz
