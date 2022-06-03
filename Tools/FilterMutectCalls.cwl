# gatk --java-options "-Xmx~{runtime_params.command_mem}m" FilterMutectCalls -V ~{unfiltered_vcf} \
#     -R ~{ref_fasta} \
#     -O ~{output_vcf} \
#     ~{"--contamination-table " + contamination_table} \
#     ~{"--tumor-segmentation " + maf_segments} \
#     ~{"--ob-priors " + artifact_priors_tar_gz} \
#     ~{"-stats " + mutect_stats} \
#     --filtering-stats filtering.stats \
#     ~{m2_extra_filtering_args}


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
  outprefix:
    type: string

outputs:
  pielups_table:
    type: File
    outputBinding:
      glob: $(inputs.outprefix).somatic.artifact-priors.tar.gz
  log:
    type: stderr

arguments:
  - position: 2
    valueFrom: FilterMutectCalls
  - position: 4
    prefix: -O
    valueFrom: $(inputs.outprefix).somatic.filtered.vcf.gz

stderr: $(inputs.outprefix).somatic.filtered.vcf.gz
